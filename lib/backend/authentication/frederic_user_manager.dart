import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:get_it/get_it.dart';

abstract class FredericAuthEvent {}

class FredericLoginEvent extends FredericAuthEvent {
  FredericLoginEvent(this.email, this.password);

  final String email;
  final String password;
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

class FredericUserManager extends Bloc<FredericAuthEvent, FredericUser> {
  FredericUserManager() : super(FredericUser(''));

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userStreamSubscription;

  @override
  Stream<FredericUser> mapEventToState(FredericAuthEvent event) async* {
    if (event is FredericUserDataChangedEvent) {
      yield FredericUser(FirebaseAuth.instance.currentUser?.uid ?? '',
          snapshot: event.snapshot);
    } else if (event is FredericLoginEvent) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
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
      if (GetIt.instance.isRegistered<FredericBackend>()) {
        FredericBackend.instance.dispose();
      }
      GetIt.instance.unregister<FredericBackend>();
      GetIt.instance.registerSingleton<FredericBackend>(FredericBackend());
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
  }

  @override
  void onTransition(Transition<FredericAuthEvent, FredericUser> transition) {
    if (transition.event is FredericLoginEvent ||
        transition.event is FredericSignupEvent) {
      _userStreamSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(transition.nextState.uid)
          .snapshots()
          .listen((snapshot) => add(FredericUserDataChangedEvent(snapshot)));
    } else if (transition.event is FredericSignOutEvent) {
      _userStreamSubscription?.cancel();
    }

    print(transition);
    super.onTransition(transition);
  }

  void changePassword(String newPassword) {
    throw UnimplementedError('change password not implemented');
  }

  ///
  /// Also updates the name in the database
  ///
  set name(String value) {
    if (super.state.uid == '') return;
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(super.state.uid)
          .update({'name': value});
    }
  }

  ///
  /// Also updates the progressMonitors in the database
  ///
  set progressMonitors(List<String> value) {
    if (super.state.uid == '') return;
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(super.state.uid)
          .update({'progressmonitors': value});
    }
  }

  ///
  /// Also updates the activeWorkouts in the database
  ///
  set activeWorkouts(List<String> value) {
    if (super.state.uid == '') return;
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(super.state.uid)
          .update({'activeworkouts': value});
    }
  }

  ///
  /// Also updates the image in the database
  ///
  set image(String value) {
    if (super.state.uid == '') return;
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(super.state.uid)
          .update({'image': value});
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
