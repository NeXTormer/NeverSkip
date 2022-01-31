import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/streak_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/concurrency/frederic_concurrency_message.dart';
import 'package:frederic/backend/database/frederic_auth_interface.dart';
import 'package:frederic/main.dart';

import 'frederic_auth_event.dart';

class FredericUserManager extends Bloc<FredericAuthEvent, FredericUser> {
  FredericUserManager(
      {required FredericBackend backend, required this.authInterface})
      : _backend = backend,
        super(FredericUser.noAuth()) {
    streakManager = StreakManager(this, _backend);
    authInterface.registerDataChangedListener(handleUserDataUpdate);
  }

  late final StreakManager streakManager;
  final FredericAuthInterface authInterface;
  final FredericBackend _backend;

  bool firstUserSignUp = false;

  bool firestoreDataWasLoadedAtLeastOnce = false;

  @override
  Stream<FredericUser> mapEventToState(FredericAuthEvent event) async* {
    if (event is FredericUserDataChangedEvent) {
      yield await event.process(this);
      FredericBackend.instance.waitUntilCoreDataIsLoaded().then((value) {
        streakManager.handleUserDataChange();
      });
    } else {
      yield await event.process(this);
    }
    if (event is FredericRestoreLoginStatusEvent ||
        event is FredericEmailLoginEvent ||
        event is FredericOAuthSignInEvent) {
      FredericBackend.instance.messageBus.add(FredericConcurrencyMessage(
          FredericConcurrencyMessageType.UserHasAuthenticated));
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

  void userDataChanged() {
    authInterface.update(state);
    add(FredericUserDataChangedEvent());
  }

  @override
  void onTransition(
      Transition<FredericAuthEvent, FredericUser> transition) async {
    // print("USER TRANSITION");
    // print("event: ${transition.event}");
    // print('current: ${transition.currentState.activeWorkouts}');
    // print("===");
    // print('next: ${transition.nextState.activeWorkouts}');
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
    FredericBase.forceFullRestart(context);
  }

  void addActiveWorkout(String workoutID) {
    state.addActiveWorkout(workoutID);
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
