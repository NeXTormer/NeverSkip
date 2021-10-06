import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/streak_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';

import 'frederic_auth_event.dart';

class FredericUserManager extends Bloc<FredericAuthEvent, FredericUser> {
  FredericUserManager({required FredericBackend backend})
      : _backend = backend,
        super(FredericUser('', waiting: true)) {
    FirebaseAuth.instance.authStateChanges().listen((userdata) {
      if (userdata != null) {
        add(FredericRestoreLoginStatusEvent(userdata.uid));
      }
    });
    streakManager = StreakManager(this, _backend);
  }

  late final StreakManager streakManager;
  final FredericBackend _backend;

  bool firestoreDataWasLoadedAtLeastOnce = false;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userStreamSubscription;

  @override
  Stream<FredericUser> mapEventToState(FredericAuthEvent event) async* {
    if (event is FredericRestoreLoginStatusEvent) {
      if (state.waiting == true) {
        yield await event.process(this);
      }
    } else if (event is FredericUserDataChangedEvent) {
      yield await event.process(this);
      FredericBackend.instance.waitUntilCoreDataIsLoaded().then((value) {
        streakManager.handleUserDataChange();
      });
    } else {
      event.process(this);
    }
  }

  //TODO: when adding apple login: add event to this 'if'
  @override
  void onTransition(Transition<FredericAuthEvent, FredericUser> transition) {
    if (transition.event is FredericEmailLoginEvent ||
        transition.event is FredericEmailSignupEvent ||
        transition.event is FredericOAuthSignInEvent ||
        transition.event is FredericRestoreLoginStatusEvent) {
      _userStreamSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(transition.nextState.uid)
          .snapshots()
          .listen((snapshot) => add(FredericUserDataChangedEvent(snapshot)));
    } else if (transition.event is FredericSignOutEvent) {
      _userStreamSubscription?.cancel();
    }
    if (false) {
      print('==========Frederic User Transition==========');
      print(transition);
      print('============================================');
    }

    super.onTransition(transition);
  }

  void signOut(BuildContext context) async {
    await _userStreamSubscription?.cancel();
    FirebaseAuth.instance.signOut();
    FredericBase.forceFullRestart(context);
  }

  void changePassword(String newPassword) {
    throw UnimplementedError('change password not implemented yet');
  }

  void addActiveWorkout(String workoutID) {
    List<String> activeWorkoutsList = state.activeWorkouts;
    if (!activeWorkoutsList.contains(workoutID)) {
      activeWorkoutsList.add(workoutID);
      state.activeWorkouts = activeWorkoutsList;
    }
  }

  void removeActiveWorkout(String workoutID) {
    List<String> activeWorkoutsList = state.activeWorkouts;
    if (activeWorkoutsList.contains(workoutID)) {
      activeWorkoutsList.remove(workoutID);
      state.activeWorkouts = activeWorkoutsList;
    }
  }

  Future<void> createUserEntryInDB(
      {required String uid,
      String? name,
      String? image,
      String? username}) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name ?? '',
      'image': image ??
          'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/defaults%2Fdefault-user-image.png?alt=media&token=f275c43b-bb43-40e2-943d-8afb9e3f7c4e',
      'username': username ?? null,
      'uid': uid,
      'activeworkouts': <String>[],
      'progressmonitors': <String>[]
    });
  }
}
