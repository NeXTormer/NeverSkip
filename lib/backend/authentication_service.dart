import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';

class AuthenticationService {
  AuthenticationService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password.';
      }
      return 'Invalid credentials.';
    }
  }

  Future<String> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await FredericUser.createUserEntryInDB(userCredential.user!.uid, name);
        FredericBackend.instance.logIn(userCredential.user!.uid);
        return 'success';
      } else {
        return 'error-user-is-null';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password is too weak.';
      }
      if (e.code == 'email-already-in-use') {
        return 'This email address is already used.';
      }
      return e.message ?? 'other-error';
    } catch (e) {
      print(e);
      return 'other-error';
    }
  }
}
