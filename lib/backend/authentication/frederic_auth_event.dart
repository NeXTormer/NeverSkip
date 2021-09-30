import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/concurrency/frederic_concurrency_message.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../frederic_backend.dart';
import 'frederic_user.dart';
import 'frederic_user_manager.dart';

abstract class FredericAuthEvent {
  Future<FredericUser> process(FredericUserManager userManager);
}

class FredericEmailLoginEvent extends FredericAuthEvent {
  FredericEmailLoginEvent(this.email, this.password);

  final String email;
  final String password;

  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences.getInstance()
          .then((value) => value.setBool('wasLoggedIn', true));
      return FredericUser(FirebaseAuth.instance.currentUser?.uid ?? '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return FredericUser('', statusMessage: 'The email does not exist.');
      } else if (e.code == 'wrong-password') {
        return FredericUser('', statusMessage: 'Wrong password.');
      }
      return FredericUser('', statusMessage: 'Invalid credentials');
    }
  }
}

class FredericGoogleLoginEvent extends FredericAuthEvent {
  FredericGoogleLoginEvent(this.googleAccount);

  final GoogleSignInAccount googleAccount;

  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    final authentication = await googleAccount.authentication;
    final authCredentials = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken);
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredentials);

    if (userCredential.additionalUserInfo?.isNewUser ?? true) {
      await userManager.createUserEntryInDB(
          uid: userCredential.user!.uid,
          name: userCredential.user?.displayName,
          image: userCredential.user?.photoURL,
          username: userCredential.additionalUserInfo?.username);
      return FredericUser(userCredential.user!.uid);
    }

    return FredericUser(FirebaseAuth.instance.currentUser?.uid ?? '');
  }
}

class FredericRestoreLoginStatusEvent extends FredericAuthEvent {
  FredericRestoreLoginStatusEvent(this.uid);
  final String uid;

  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    return FredericUser(uid, waiting: false);
  }
}

class FredericEmailSignupEvent extends FredericAuthEvent {
  FredericEmailSignupEvent(this.name, this.email, this.password);

  final String name;
  final String email;
  final String password;

  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userManager.createUserEntryInDB(
            uid: userCredential.user!.uid, name: name);
        return FredericUser(userCredential.user!.uid);
      } else {
        return FredericUser('',
            statusMessage: 'Sign up error. Please contact support.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return FredericUser('', statusMessage: 'The password is too weak.');
      }
      if (e.code == 'email-already-in-use') {
        return FredericUser('',
            statusMessage: 'This email address is already used');
      }
      return FredericUser('',
          statusMessage: 'Sign up error. Please contact support.');
    } catch (e) {
      return FredericUser('',
          statusMessage: 'Sign up error. Please contact support.');
    }
  }
}

class FredericSignOutEvent extends FredericAuthEvent {
  FredericSignOutEvent([this.reason]);
  final String? reason;

  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    await FirebaseAuth.instance.signOut();
    return FredericUser('');
  }
}

class FredericUserDataChangedEvent extends FredericAuthEvent {
  FredericUserDataChangedEvent(this.snapshot);
  final DocumentSnapshot<Map<String, dynamic>> snapshot;

  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    if (!userManager.firestoreDataWasLoadedAtLeastOnce) {
      userManager.firestoreDataWasLoadedAtLeastOnce = true;
      FredericBackend.instance.messageBus.add(FredericConcurrencyMessage(
          FredericConcurrencyMessageType.UserHasAuthenticated));
    }

    return FredericUser(FirebaseAuth.instance.currentUser?.uid ?? '',
        snapshot: snapshot);
  }
}
