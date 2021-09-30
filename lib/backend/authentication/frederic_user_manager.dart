import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/streak_manager.dart';
import 'package:frederic/backend/backend.dart';

import 'frederic_auth_event.dart';

class FredericUserManager extends Bloc<FredericAuthEvent, FredericUser> {
  FredericUserManager(
      {this.onLoadData,
      this.logTransition = false,
      required FredericBackend backend})
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
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userStreamSubscription;
  List<Completer<void>> _userHasAuthenticatedCompleters = <Completer<void>>[];

  bool hasLoaded = false;
  final bool logTransition;
  Function? onLoadData;

  @override
  Stream<FredericUser> mapEventToState(FredericAuthEvent event) async* {
    if (event is FredericRestoreLoginStatusEvent) {
      if (state.waiting == true) {
        yield await event.process(this);
      }
    } else if (event is FredericUserDataChangedEvent) {
      yield await event.process(this);
      FredericBackend.instance.waitUntilDataIsLoaded().then((value) {
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
        transition.event is FredericGoogleLoginEvent ||
        transition.event is FredericRestoreLoginStatusEvent) {
      _userStreamSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(transition.nextState.uid)
          .snapshots()
          .listen((snapshot) => add(FredericUserDataChangedEvent(snapshot)));
    } else if (transition.event is FredericSignOutEvent) {
      _userStreamSubscription?.cancel();
    }
    if (logTransition) {
      print('==========Frederic User Transition==========');
      print(transition);
      print('============================================');
    }

    super.onTransition(transition);
  }

  Future<void> waitForUserAuthentication() async {
    if (hasLoaded) return;
    Completer<void> completer = Completer<void>();
    _userHasAuthenticatedCompleters.add(completer);
    return completer.future;
  }

  void hasLoadedDataCallback() {
    if (hasLoaded) return;
    hasLoaded = true;
    for (Completer<void> completer in _userHasAuthenticatedCompleters) {
      completer.complete();
      print('COMPLETE COMPLETERS==================================');
    }
    _userHasAuthenticatedCompleters.clear();
    onLoadData?.call();
  }

  void changePassword(String newPassword) {
    throw UnimplementedError('change password not implemented');
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
          'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/defaultimages%2Fdefault-profile-screen.jpg?alt=media&token=52f200e9-fac8-4295-bf7d-01b59f92a987',
      'username': username ?? null,
      'uid': uid,
      'activeworkouts': <String>[],
      'progressmonitors': <String>[]
    });
  }
}
