import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:frederic/backend/analytics/frederic_analytics_message.dart';
import 'package:frederic/backend/util/event_bus/frederic_base_message.dart';
import 'package:frederic/backend/util/event_bus/frederic_message_processor.dart';

class FredericAnalyticsService implements FredericMessageProcessor {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  bool acceptsMessage(FredericBaseMessage event) {
    return event is FredericAnalyticsMessage;
  }

  @override
  void processMessage(FredericBaseMessage event) {
    // TODO: implement processEvent
  }

  Future<void> setUserProperties({required String userID}) async {
    await _analytics.setUserId(userID);
  }

  Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  Future<void> logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  Future<void> logGoalCreated() async {
    await _analytics.logEvent(name: 'create_goal');
  }

  void logPlayerStreak(int streak) {}
}
