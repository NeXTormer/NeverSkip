import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
        super(FredericUser('', authState: FredericAuthState.NotAuthenticated)) {
    streakManager = StreakManager(this, _backend);

    FirebaseAuth.instance.authStateChanges().listen((userdata) {
      if (userdata != null) {
        add(FredericRestoreLoginStatusEvent(userdata));
      }
    });
  }

  late final StreakManager streakManager;
  final FredericAuthInterface authInterface;
  final FredericBackend _backend;

  bool firstUserSignUp = false;

  bool firestoreDataWasLoadedAtLeastOnce = false;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userStreamSubscription;

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
  }

  void userDataChanged() {
    add(FredericUserDataChangedEvent());
  }

  //TODO: Add event to 'if' when implementing new login method
  @override
  void onTransition(
      Transition<FredericAuthEvent, FredericUser> transition) async {
    if ((transition.event is FredericEmailLoginEvent ||
            transition.event is FredericEmailSignupEvent ||
            transition.event is FredericOAuthSignInEvent ||
            transition.event is FredericRestoreLoginStatusEvent) &&
        transition.nextState.uid != '') {
      try {} catch (e) {
        print('===============');
        print(e);
      }
    } else if (transition.event is FredericSignOutEvent) {
      _userStreamSubscription?.cancel();
    }

    print("USER TRANSITION");
    print("event: ${transition.event}");
    print('current: ${transition.currentState.activeWorkouts}');
    print("===");
    print('next: ${transition.nextState.activeWorkouts}');
    print('\n\n');
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('==========Frederic User Bloc Error =================');
    super.onError(error, stackTrace);
  }

  void signOut(BuildContext context) async {
    await _userStreamSubscription?.cancel();
    FirebaseAuth.instance.signOut();
    FredericBase.forceFullRestart(context);
  }

  void addActiveWorkout(String workoutID) {
    state.addActiveWorkout(workoutID);
  }

  void removeActiveWorkout(String workoutID) {
    state.removeActiveWorkout(workoutID);
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
