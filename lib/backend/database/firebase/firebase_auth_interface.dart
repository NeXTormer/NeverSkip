import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/backend/database/frederic_auth_interface.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:hive/hive.dart';

class FirebaseAuthInterface implements FredericAuthInterface {
  FirebaseAuthInterface(
      {required this.firebaseAuthInstance, required this.firestoreInstance}) {
    firebaseAuthInstance.authStateChanges().listen((User? user) {
      if (user != null) {
        _onUpdateData?.call(
            FredericUser.only(user.uid, user.email ?? 'no-mail'), true);
      }
    });

    Hive.openBox<Map<dynamic, dynamic>>(_name).then((value) => _box = value);
  }

  final FirebaseAuth firebaseAuthInstance;
  final FirebaseFirestore firestoreInstance;

  void Function(FredericUser, bool)? _onUpdateData;

  final String _name = 'userdata';
  Box<Map<dynamic, dynamic>>? _box;

  @override
  Future<void> changePassword(FredericUser user, String newPassword) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<bool> reAuthenticate(FredericUser user, String password) async {
    AuthCredential cred =
        EmailAuthProvider.credential(email: user.email, password: password);
    bool success = false;
    try {
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(cred);
      success = true;
    } on FirebaseAuthException {}
    return success;
  }

  @override
  Future<void> deleteAccount(FredericUser user) async {
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
        return FredericUser.noAuth(
          statusMessage: 'Login Error. Try Again later.',
        );
      return getUserData(
          userCredential.user!.uid, userCredential.user!.email ?? '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return FredericUser.noAuth(
          statusMessage: 'The email does not exist.',
        );
      } else if (e.code == 'wrong-password') {
        return FredericUser.noAuth(
          statusMessage: 'Wrong password.',
        );
      }
      return FredericUser.noAuth(
        statusMessage: 'Invalid credentials',
      );
    }
  }

  @override
  Future<FredericUser> logInOAuth(OAuthCredential credential,
      {String? name}) async {
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    String? displayName = name ?? userCredential.user?.displayName;
    String? image = userCredential.user?.photoURL;

    if (userCredential.additionalUserInfo?.isNewUser ?? true) {
      return _createDBEntry(
          id: userCredential.user!.uid,
          email: userCredential.user?.email ?? 'error-no-email',
          name: displayName,
          image: image,
          username: userCredential.additionalUserInfo?.username);
    } else {
      if (userCredential.user == null)
        return FredericUser.noAuth(
          statusMessage: 'Login Error. Try Again later.',
        );
      return getUserData(
          userCredential.user!.uid, userCredential.user!.email ?? '');
    }
  }

  Future<FredericUser> _reloadUserData(
      String uid, String email, bool callCallback) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await firestoreInstance.collection('users').doc(uid).get();

      if (!userDocument.exists) {
        FredericProfiler.log(
            'User Document not found, probably because auth stream updated while doc was not yet created');
        return FredericUser.noAuth();
      }
      firestoreInstance
          .collection('users')
          .doc(uid)
          .update({'last_login': Timestamp.now()});

      if (_box == null) _box = await Hive.openBox(_name);
      _box!.put(0, Map.from(userDocument.data()!));

      final user = FredericUser.fromMap(uid, email, userDocument.data()!);
      if (callCallback) {
        _onUpdateData?.call(user, false);
      }
      return user;
    } catch (e) {
      return FredericUser.noAuth();
    }
  }

  @override
  Future<FredericUser> getUserData(String uid, String email) async {
    _box = await Hive.openBox(_name);
    if ((_box?.isEmpty ?? true)) return _reloadUserData(uid, email, false);
    final data = _box?.get(0);

    if (data != null && data['uid'] == uid) {
      FredericProfiler.log(
          'FirebaseAuthInterface: UID matching, using cached data');

      _reloadUserData(uid, email, true); // NO AWAIT, load data from db
      return FredericUser.fromMap(uid, email, Map<String, dynamic>.from(data));
    }
    if (data != null && data['uid'] != uid) {
      FredericProfiler.log(
          'FirebaseAuthInterface: UID NOT matching, reloading from firestore');
    }
    return _reloadUserData(uid, email, false);
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
        return FredericUser.noAuth(
            statusMessage: 'Sign up error. Please contact support.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return FredericUser.noAuth(statusMessage: 'The password is too weak.');
      }
      if (e.code == 'email-already-in-use') {
        return FredericUser.noAuth(
            statusMessage: 'This email address is already used');
      }
      return FredericUser.noAuth(statusMessage: 'Sign up error. [${e.code}]');
    } catch (e) {
      return FredericUser.noAuth(
          statusMessage: 'Sign up error. Please contact support. [SUOE]');
    }
  }

  @override
  Future<void> update(FredericUser user) async {
    if (_box == null) _box = await Hive.openBox(_name);
    _box!.put(0, user.toMap());

    return firestoreInstance
        .collection('users')
        .doc(user.id)
        .update(user.toMap());
  }

  Future<FredericUser> _createDBEntry(
      {required String id,
      required String email,
      String? name,
      String? image,
      String? username}) async {
    DocumentSnapshot<Map<String, dynamic>> defaultDoc = await firestoreInstance
        .collection('defaults')
        .doc('default_user')
        .get();

    await firestoreInstance.collection('users').doc(id).set({
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

    if (userDocument.data() == null) {
      print('UDNFAS');
      return FredericUser.noAuth(
          statusMessage:
              'Sign up Error. Please contact support. [Error UDNFAS]');
    }

    return FredericUser.fromMap(id, email, userDocument.data()!);
  }

  @override
  void registerDataChangedListener(
      void Function(FredericUser user, bool restoreLoginStatus) onDataChanged) {
    _onUpdateData = onDataChanged;
  }
}
