import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class FredericAnalytics {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> setUserProperties({required String userID}) async {
    await analytics.setUserId(userID);
  }

  Future<void> logLogin() async {
    await analytics.logLogin(loginMethod: 'email');
  }

  Future<void> logSignUp() async {
    await analytics.logSignUp(signUpMethod: 'email');
  }

  Future<void> logGoalCreated() async {
    await analytics.logEvent(name: 'create_goal');
  }
}
