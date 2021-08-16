import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/streak_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final FredericBackend _backend;
  late final StreakManager streakManager;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userStreamSubscription;

  bool hasLoaded = false;
  final bool logTransition;
  Function? onLoadData;

  @override
  Stream<FredericUser> mapEventToState(FredericAuthEvent event) async* {
    if (event is FredericUserDataChangedEvent) {
      if (!hasLoaded) {
        hasLoaded = true;
        onLoadData?.call();
      }
      yield FredericUser(FirebaseAuth.instance.currentUser?.uid ?? '',
          snapshot: event.snapshot);
    } else if (event is FredericRestoreLoginStatusEvent) {
      if (state.waiting == true) {
        yield FredericUser(event.uid, waiting: false);
      }
    } else if (event is FredericLoginEvent) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        SharedPreferences.getInstance()
            .then((value) => value.setBool('wasLoggedIn', true));
        yield FredericUser(FirebaseAuth.instance.currentUser?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          yield FredericUser('', statusMessage: 'The email does not exist.');
        } else if (e.code == 'wrong-password') {
          yield FredericUser('', statusMessage: 'Wrong password.');
        }
        yield FredericUser('', statusMessage: 'Invalid credentials');
      }
    } else if (event is FredericSignOutEvent) {
      FirebaseAuth.instance.signOut();
      yield FredericUser('');
    } else if (event is FredericSignupEvent) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: event.email, password: event.password);
        if (userCredential.user != null) {
          await _createUserEntryInDB(userCredential.user!.uid, event.name);
          yield FredericUser(userCredential.user!.uid);
        } else {
          yield FredericUser('',
              statusMessage: 'Sign up error. Please contact support.');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          yield FredericUser('', statusMessage: 'The password is too weak.');
        }
        if (e.code == 'email-already-in-use') {
          yield FredericUser('',
              statusMessage: 'This email address is already used');
        }
        yield FredericUser('',
            statusMessage: 'Sign up error. Please contact support.');
      } catch (e) {
        yield FredericUser('',
            statusMessage: 'Sign up error. Please contact support.');
      }
    }
    streakManager.update();
  }

  @override
  void onTransition(Transition<FredericAuthEvent, FredericUser> transition) {
    if (transition.event is FredericLoginEvent ||
        transition.event is FredericSignupEvent ||
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

  Future<void> _createUserEntryInDB(String uid, String name) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'image':
          'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/defaultimages%2Fdefault-profile-screen.jpg?alt=media&token=52f200e9-fac8-4295-bf7d-01b59f92a987',
      'uid': uid,
      'activeworkouts': <String>[],
      'progressmonitors': <String>[]
    });
  }
}

abstract class FredericAuthEvent {}

class FredericLoginEvent extends FredericAuthEvent {
  FredericLoginEvent(this.email, this.password);

  final String email;
  final String password;
}

class FredericRestoreLoginStatusEvent extends FredericAuthEvent {
  FredericRestoreLoginStatusEvent(this.uid);
  final String uid;
}

class FredericSignupEvent extends FredericAuthEvent {
  FredericSignupEvent(this.name, this.email, this.password);

  final String name;
  final String email;
  final String password;
}

class FredericSignOutEvent extends FredericAuthEvent {
  FredericSignOutEvent([this.reason]);
  final String? reason;
}

class FredericUserDataChangedEvent extends FredericAuthEvent {
  FredericUserDataChangedEvent(this.snapshot);
  final DocumentSnapshot<Map<String, dynamic>> snapshot;
}
