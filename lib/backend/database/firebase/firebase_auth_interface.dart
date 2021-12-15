import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/backend/database/frederic_auth_interface.dart';

class FirebaseAuthInterface implements FredericAuthInterface {
  FirebaseAuthInterface(
      {required this.firebaseAuthInstance, required this.firestoreInstance});
  final FirebaseAuth firebaseAuthInstance;
  final FirebaseFirestore firestoreInstance;

  @override
  Future<void> changePassword(FredericUser user, String currentPassword) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount(FredericUser user, String currentPassword) async {
    await firestoreInstance.collection('users').doc(user.id).delete();
    await FirebaseAuth.instance.currentUser?.delete();
  }

  @override
  Future<FredericUser> logIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuthInstance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null)
        return FredericUser('',
            statusMessage: 'Login Error. Try Again later.',
            authState: FredericAuthState.NotAuthenticated);
      return getUserData(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return FredericUser('',
            statusMessage: 'The email does not exist.',
            authState: FredericAuthState.NotAuthenticated);
      } else if (e.code == 'wrong-password') {
        return FredericUser('',
            statusMessage: 'Wrong password.',
            authState: FredericAuthState.NotAuthenticated);
      }
      return FredericUser('',
          statusMessage: 'Invalid credentials',
          authState: FredericAuthState.NotAuthenticated);
    }
  }

  @override
  Future<FredericUser> logInOAuth(OAuthCredential credential) async {
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    String? name = userCredential.user?.displayName;
    String? image = userCredential.user?.photoURL;

    if (name == null) {
      //TODO: Apple; get name and picture
    }

    if (userCredential.additionalUserInfo?.isNewUser ?? true) {
      return _createDBEntry(
          id: userCredential.user!.uid,
          name: name,
          image: image,
          username: userCredential.additionalUserInfo?.username);
    } else {
      if (userCredential.user == null)
        return FredericUser('',
            statusMessage: 'Login Error. Try Again later.',
            authState: FredericAuthState.NotAuthenticated);
      return getUserData(userCredential.user!.uid);
    }
  }

  @override
  Future<FredericUser> getUserData(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firestoreInstance.collection('users').doc(uid).get();

    if (!userDocument.exists)
      return FredericUser('',
          statusMessage: 'Login Error. Please contact support. [Error UDNF]',
          authState: FredericAuthState.NotAuthenticated);
    firestoreInstance
        .collection('users')
        .doc(uid)
        .update({'last_login': Timestamp.now()});

    return FredericUser.fromMap(uid, null, userDocument.data()!);
  }

  @override
  Future<void> logOut() {
    return firebaseAuthInstance.signOut();
  }

  @override
  Future<FredericUser> signUp(
      {required String email,
      required String name,
      required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return _createDBEntry(
            id: userCredential.user!.uid,
            name: name,
            email: userCredential.user!.email ?? '');
      } else {
        return FredericUser('',
            authState: FredericAuthState.NotAuthenticated,
            statusMessage: 'Sign up error. Please contact support.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return FredericUser('',
            authState: FredericAuthState.NotAuthenticated,
            statusMessage: 'The password is too weak.');
      }
      if (e.code == 'email-already-in-use') {
        return FredericUser('',
            authState: FredericAuthState.NotAuthenticated,
            statusMessage: 'This email address is already used');
      }
      return FredericUser('',
          authState: FredericAuthState.NotAuthenticated,
          statusMessage: 'Sign up error. [${e.code}]');
    } catch (e) {
      return FredericUser('',
          authState: FredericAuthState.NotAuthenticated,
          statusMessage: 'Sign up error. Please contact support. [SUOE]');
    }
  }

  @override
  Future<void> update(FredericUser user) {
    return firestoreInstance
        .collection('users')
        .doc(user.id)
        .update(user.toMap());
  }

  Future<FredericUser> _createDBEntry(
      {required String id,
      String? email,
      String? name,
      String? image,
      String? username}) async {
    DocumentSnapshot<Map<String, dynamic>> defaultDoc = await firestoreInstance
        .collection('defaults')
        .doc('default_user')
        .get();

    firestoreInstance.collection('users').doc(id).set({
      'id': id,
      'name': name ?? defaultDoc.data()?['name'] ?? '',
      'image': image ?? defaultDoc.data()?['image'] ?? '',
      'username': username ?? null,
      'activeworkouts': defaultDoc.data()?['activeworkouts'] ?? <String>[],
      'progressmonitors': defaultDoc.data()?['progressmonitors'] ?? <String>[],
      'streakstart': null,
      'streaklatest': null,
    });

    final userDocument =
        await firestoreInstance.collection('users').doc(id).get();
    if (userDocument.data() == null)
      return FredericUser('',
          authState: FredericAuthState.NotAuthenticated,
          statusMessage:
              'Sign up Error. Please contact support. [Error UDNFAS]');
    return FredericUser.fromMap(id, email, userDocument.data()!);
  }
}
