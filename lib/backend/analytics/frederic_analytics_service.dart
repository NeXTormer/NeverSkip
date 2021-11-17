import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:frederic/theme/frederic_theme.dart';

class FredericAnalytics {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> enable() {
    return analytics.setAnalyticsCollectionEnabled(true);
  }

  Future<void> disable() {
    return analytics.setAnalyticsCollectionEnabled(false);
  }

  Future<void> logLogin(String method) {
    return analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp(String method) {
    return analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logGoalCreated() {
    return analytics.logEvent(name: 'create-goal');
  }

  Future<void> logGoalDeleted() {
    return analytics.logEvent(name: 'delete-goal');
  }

  Future<void> logWorkoutCreated() {
    return analytics.logEvent(name: 'create-workout');
  }

  Future<void> logWorkoutSaved() {
    return analytics.logEvent(name: 'save-workout');
  }

  Future<void> logWorkoutDeleted() {
    return analytics.logEvent(name: 'delete-workout');
  }

  Future<void> logAddProgressOnActivity() {
    return analytics.logEvent(name: 'add-progress-using-activity');
  }

  Future<void> logAddProgressOnCalendar() {
    return analytics.logEvent(name: 'add-progress-using-calendar');
  }

  Future<void> logCompleteCalendarDay() {
    return analytics.logEvent(name: 'complete-calendar-day');
  }

  Future<void> logEnableCustomWorkout() {
    return analytics.logEvent(name: 'enable-custom-workout');
  }

  Future<void> logEnableGlobalWorkout() {
    return analytics.logEvent(name: 'enable-global-workout');
  }

  Future<void> logDisableCustomWorkout() {
    return analytics.logEvent(name: 'disable-custom-workout');
  }

  Future<void> logDisableGlobalWorkout() {
    return analytics.logEvent(name: 'disable-global-workout');
  }

  Future<void> logEnterSettingsScreen() {
    return analytics.setCurrentScreen(screenName: 'settings-screen');
  }

  Future<void> logEnterUserSettingsScreen() {
    return analytics.setCurrentScreen(screenName: 'user-settings-screen');
  }

  Future<void> logEnterHomeScreen() {
    return analytics.setCurrentScreen(screenName: 'Home');
  }

  Future<void> logChangeColorTheme(FredericColorTheme theme) {
    return analytics.logEvent(
        name: 'change-color-theme', parameters: {'theme': theme.name});
  }
}
