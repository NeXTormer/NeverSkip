import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';

abstract class FredericAuthInterface {
  Future<FredericUser> signUp(
      {required String email, required String name, required String password});
  Future<FredericUser> logIn({required String email, required String password});
  Future<FredericUser> logInOAuth(OAuthCredential credential, {String? name});
  Future<FredericUser> getUserData(String uid, String email);
  Future<void> logOut();

  void registerDataChangedListener(
      void Function(FredericUser, bool) onDataChanged);

  Future<void> update(FredericUser user);
  Future<bool> reAuthenticate(FredericUser user, String password);
  Future<void> changePassword(FredericUser user, String newPassword);
  Future<void> deleteAccount(FredericUser user);
}
