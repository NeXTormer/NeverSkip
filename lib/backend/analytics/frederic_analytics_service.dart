import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:frederic/theme/frederic_theme.dart';

class FredericAnalytics {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> enable() async {
    await analytics.setAnalyticsCollectionEnabled(true);
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
    return FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  Future<void> disable() async {
    await analytics.setAnalyticsCollectionEnabled(false);
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
    return FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  void logCurrentScreen(String screen) {
    analytics.setCurrentScreen(screenName: screen);
  }

  Future<void> logLogin(String method) {
    return analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp(String method) {
    return analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logGoalCreated() {
    return analytics.logEvent(name: 'create_goal');
  }

  Future<void> logGoalDeleted() {
    return analytics.logEvent(name: 'delete_goal');
  }

  Future<void> logGoalSavedAsAchievement() {
    return analytics.logEvent(name: 'goal_saved_as_achievement');
  }

  Future<void> logAchievementDeleted() {
    return analytics.logEvent(name: 'delete_achievement');
  }

  Future<void> logWorkoutCreated() {
    return analytics.logEvent(name: 'create_workout');
  }

  Future<void> logWorkoutSaved() {
    return analytics.logEvent(name: 'save_workout');
  }

  Future<void> logWorkoutDeleted() {
    return analytics.logEvent(name: 'delete_workout');
  }

  Future<void> logAddProgressOnActivity() {
    return analytics.logEvent(name: 'add_progress_using_activity');
  }

  Future<void> logAddProgressOnCalendar() {
    return analytics.logEvent(name: 'add_progress_using_calendar');
  }

  Future<void> logAddProgressOnWorkoutPlayer() {
    return analytics.logEvent(name: 'add_progress_using_workout_player');
  }

  Future<void> logCompleteCalendarDay() {
    return analytics.logEvent(name: 'complete_calendar_day');
  }

  Future<void> logEnableCustomWorkout() {
    return analytics.logEvent(name: 'enable_custom_workout');
  }

  Future<void> logEnableGlobalWorkout() {
    return analytics.logEvent(name: 'enable_global_workout');
  }

  Future<void> logDisableCustomWorkout() {
    return analytics.logEvent(name: 'disable_custom_workout');
  }

  Future<void> logDisableGlobalWorkout() {
    return analytics.logEvent(name: 'disable_global_workout');
  }

  Future<void> logEnterSettingsScreen() {
    return analytics.setCurrentScreen(screenName: 'settings_screen');
  }

  Future<void> logEnterUserSettingsScreen() {
    return analytics.setCurrentScreen(screenName: 'user_settings_screen');
  }

  Future<void> logEnterHomeScreen() {
    return analytics.setCurrentScreen(screenName: 'Home');
  }

  Future<void> logChangeColorTheme(FredericColorTheme theme) {
    return analytics.logEvent(
        name: 'change_color_theme', parameters: {'theme': theme.name});
  }
}
