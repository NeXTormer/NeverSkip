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
      yield await event.process(this);
    }
  }

  //TODO: Add event to 'if' when implementing new login
  @override
  void onTransition(
      Transition<FredericAuthEvent, FredericUser> transition) async {
    if ((transition.event is FredericEmailLoginEvent ||
            transition.event is FredericEmailSignupEvent ||
            transition.event is FredericOAuthSignInEvent ||
            transition.event is FredericRestoreLoginStatusEvent) &&
        transition.nextState.uid != '') {
      // Info: maybe remove async and await for this call for better performance
      await FirebaseFirestore.instance
          .collection('users')
          .doc(transition.nextState.uid)
          .set({'last_login': Timestamp.now()}, SetOptions(merge: true));

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
    List<String> activeWorkoutsList = state.activeWorkouts.toList();

    if (!activeWorkoutsList.contains(workoutID)) {
      activeWorkoutsList.add(workoutID);
      state.activeWorkouts = activeWorkoutsList.toList();
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
    DocumentSnapshot<Map<String, dynamic>> defaultDoc = await FirebaseFirestore
        .instance
        .collection('defaults')
        .doc('default_user')
        .get();

    return FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name ?? defaultDoc.data()?['name'] ?? '',
      'image': image ?? defaultDoc.data()?['image'] ?? '',
      'username': username ?? null,
      'uid': uid,
      'activeworkouts': defaultDoc.data()?['activeworkouts'] ?? <String>[],
      'progressmonitors': defaultDoc.data()?['progressmonitors'] ?? <String>[],
      'streakstart': null,
      'streaklatest': null,
    });
  }

  Future<void> deleteUser(bool confirm) async {
    if (!confirm) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(state.uid)
        .delete();
    await FirebaseAuth.instance.currentUser!.delete();
    return;
  }
}
