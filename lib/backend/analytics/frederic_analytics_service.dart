import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:frederic/backend/analytics/frederic_analytics_event.dart';
import 'package:frederic/backend/util/event_bus/frederic_event_processor.dart';
import 'package:frederic/backend/util/event_bus/frederic_system_events.dart';

class FredericAnalyticsService implements FredericEventProcessor {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  bool acceptsEvent(FredericSystemEvent event) {
    return event is FredericAnalyticsEvent;
  }

  @override
  void processEvent(FredericSystemEvent event) {
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
