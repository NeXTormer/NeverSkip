import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../frederic_backend.dart';
import 'frederic_user.dart';
import 'frederic_user_manager.dart';

abstract class FredericAuthEvent {
  Future<FredericUser> process(FredericUserManager userManager);
}

class FredericRestoreLoginStatusEvent extends FredericAuthEvent {
  FredericRestoreLoginStatusEvent(this.user);
  User user;

  @override
  Future<FredericUser> process(FredericUserManager userManager) {
    return userManager.authInterface.getUserData(user.uid, user.email ?? '');
  }
}

class FredericEmailLoginEvent extends FredericAuthEvent {
  FredericEmailLoginEvent(this.email, this.password);

  final String email;
  final String password;

  @override
  Future<FredericUser> process(FredericUserManager userManager) {
    FredericBackend.instance.analytics.analytics.logLogin(loginMethod: 'email');
    SharedPreferences.getInstance()
        .then((value) => value.setBool('wasLoggedIn', true));
    return userManager.authInterface.logIn(email: email, password: password);
  }
}

class FredericOAuthSignInEvent extends FredericAuthEvent {
  FredericOAuthSignInEvent(this.authCredential, [this.context]);

  final OAuthCredential authCredential;
  final BuildContext? context;

  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    FredericBackend.instance.analytics.analytics.logLogin(loginMethod: 'oauth');
    return userManager.authInterface.logInOAuth(authCredential);
  }
}

class FredericEmailSignupEvent extends FredericAuthEvent {
  FredericEmailSignupEvent(this.name, this.email, this.password);

  final String name;
  final String email;
  final String password;

  @override
  Future<FredericUser> process(FredericUserManager userManager) {
    FredericBackend.instance.analytics.analytics
        .logSignUp(signUpMethod: 'email');
    return userManager.authInterface
        .signUp(email: email, name: name, password: password);
  }
}

class FredericSignOutEvent extends FredericAuthEvent {
  FredericSignOutEvent([this.reason]);
  final String? reason;

  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    FredericBackend.instance.analytics.analytics.logEvent(name: 'sign-out');
    FredericBackend.instance.dispose();
    await userManager.authInterface.logOut();
    return FredericUser.noAuth();
  }
}

class FredericUserDataChangedEvent extends FredericAuthEvent {
  @override
  Future<FredericUser> process(FredericUserManager userManager) async {
    // if (!userManager.firestoreDataWasLoadedAtLeastOnce) {
    //   userManager.firestoreDataWasLoadedAtLeastOnce = true;
    // FredericBackend.instance.messageBus.add(FredericConcurrencyMessage(
    //     FredericConcurrencyMessageType.UserHasAuthenticated));
    // }
    return userManager.state;
  }
}
