import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/streak_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/concurrency/frederic_concurrency_message.dart';
import 'package:frederic/backend/database/frederic_auth_interface.dart';
import 'package:frederic/main.dart';
import 'package:hive/hive.dart';

import 'frederic_auth_event.dart';

class FredericUserManager extends Bloc<FredericAuthEvent, FredericUser> {
  FredericUserManager(
      {required FredericBackend backend, required this.authInterface})
      : _backend = backend,
        super(FredericUser.noAuth()) {
    on<FredericAuthEvent>(_onEvent);
    streakManager = StreakManager(this, _backend);
    authInterface.registerDataChangedListener(handleUserDataUpdate);
  }

  late final StreakManager streakManager;
  final FredericAuthInterface authInterface;
  final FredericBackend _backend;

  bool firstUserSignUp = false;

  bool firestoreDataWasLoadedAtLeastOnce = false;

  FutureOr<void> _onEvent(
      FredericAuthEvent event, Emitter<FredericUser> emit) async {
    FredericUser? user;
    if (event is FredericUserDataChangedEvent) {
      user = await event.process(this);
      emit(user);
      FredericBackend.instance.waitUntilCoreDataIsLoaded().then((value) {
        streakManager.handleUserDataChange();
        // don't call userDataChanged() here, it will create a memory leak
      });
    } else {
      user = await event.process(this);
      emit(user);
    }

    if (event is FredericRestoreLoginStatusEvent ||
        event is FredericEmailLoginEvent) {
      if (user.id.isNotEmpty) {
        FredericBackend.instance.messageBus.add(FredericConcurrencyMessage(
            FredericConcurrencyMessageType.UserHasAuthenticated));
        print("User has authenticated [EMail, RESTORE] ($event) [$user]");
      } else {
        print("RestoreLoginStatusEvent or EmailLoginEvent without user uid");
      }
    }
    if (event is FredericOAuthSignInEvent) {
      if (user.id.isNotEmpty) {
        FredericBackend.instance.messageBus.add(FredericConcurrencyMessage(
            FredericConcurrencyMessageType.UserHasAuthenticated));
      }
      print("User has authenticated [OAuth] [$user]");
    }
    if (event is FredericEmailSignupEvent) {
      firstUserSignUp = true;
    }
  }

  void handleUserDataUpdate(FredericUser user, bool restoreLogin) {
    if (restoreLogin) {
      add(FredericRestoreLoginStatusEvent(user));
    } else {
      add(FredericUserDataChangedEvent(user));
    }
  }

  FutureOr<void> userDataChanged([bool waitForUpdate = false]) async {
    if (waitForUpdate) {
      await authInterface.update(state);
    } else {
      authInterface.update(state);
    }
    state.calculateDerivedAttributes();
    add(FredericUserDataChangedEvent());
  }

  @override
  void onTransition(
      Transition<FredericAuthEvent, FredericUser> transition) async {
    // print("USER TRANSITION");
    // print("event: ${transition.event}");
    // print('current: ${transition.currentState.id}');
    // print("===");
    // print('next: ${transition.nextState.id}');
    // print('\n\n');
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('==========Frederic User Bloc Error =================');
    super.onError(error, stackTrace);
  }

  void signOut(BuildContext context) async {
    // await here is really important!
    await FirebaseAuth.instance.signOut();
    await Hive.deleteFromDisk();
    FredericBase.forceFullRestart(context);
  }

  void addActiveWorkout(String workoutID, DateTime? startDate) {
    state.addActiveWorkout(workoutID, startDate);
    userDataChanged();
  }

  void removeActiveWorkout(String workoutID) {
    state.removeActiveWorkout(workoutID);
    userDataChanged();
  }

  void addProgressMonitor(String id) {
    state.addProgressMonitor(id);
    userDataChanged();
  }

  void removeProgressMonitor(String id) {
    state.removeProgressMonitor(id);
    userDataChanged();
  }

  Future<void> createUserEntryInDB(
      {required String uid,
      String? name,
      String? image,
      String? username}) async {
    FredericBackend.instance.messageBus.add(
        FredericConcurrencyMessage(FredericConcurrencyMessageType.UserSignUp));
    firstUserSignUp = true;
  }
}
