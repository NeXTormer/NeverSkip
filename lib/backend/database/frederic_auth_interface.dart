import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';

abstract class FredericAuthInterface {
  Future<FredericUser> signUp(
      {required String email, required String name, required String password});
  Future<FredericUser> logIn({required String email, required String password});
  Future<FredericUser> logInOAuth(OAuthCredential credential);
  Future<FredericUser> getUserData(String uid);
  Future<void> logOut();

  Future<void> update(FredericUser user);
  Future<void> changePassword(FredericUser user, String currentPassword);
  Future<void> deleteAccount(FredericUser user, String currentPassword);
}
