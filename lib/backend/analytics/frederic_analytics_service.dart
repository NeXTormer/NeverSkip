import 'package:flutter/foundation.dart';
import 'package:frederic/theme/frederic_theme.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:umami_tracker/umami_tracker.dart';

abstract class FredericAnalyticsService {
  Future<void> initialize();

  Future<void> enable();

  Future<void> disable();

  Future<void> logCurrentScreen(String screen);

  Future<void> logLogin(String method);

  Future<void> logSignUp(String method);

  Future<void> logGoalCreated();

  Future<void> logGoalDeleted();

  Future<void> logGoalSavedAsAchievement();

  Future<void> logAchievementDeleted();

  Future<void> logWorkoutCreated();

  Future<void> logWorkoutSaved();

  Future<void> logWorkoutDeleted();

  Future<void> logAddProgressOnActivity([bool useSmartSuggestions = false]);

  Future<void> logAddProgressOnCalendar([bool useSmartSuggestions = false]);

  Future<void> logAddProgressOnWorkoutPlayer();

  Future<void> logCompleteCalendarDay();

  Future<void> logEnableCustomWorkout();

  Future<void> logEnableGlobalWorkout();

  Future<void> logDisableCustomWorkout();

  Future<void> logDisableGlobalWorkout();

  Future<void> logEnterSettingsScreen();

  Future<void> logEnterUserSettingsScreen();

  Future<void> logChangeColorTheme(FredericColorTheme theme);
}

// class GoogleAnalyticsService extends FredericAnalyticsService {
//   // Future<void> initialize() async {
//   //   return;
//   // }
//   //
//   // Future<void> enable() async {
//   //   await analytics.setAnalyticsCollectionEnabled(true);
//   //   await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
//   //   return FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//   // }
//   //
//   // Future<void> disable() async {
//   //   await analytics.setAnalyticsCollectionEnabled(false);
//   //   await FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
//   //   return FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
//   // }
//   //
//   // void logCurrentScreen(String screen) {
//   //   analytics.setCurrentScreen(screenName: screen);
//   // }
//   //
//   // Future<void> logLogin(String method) {
//   //   return analytics.logLogin(loginMethod: method);
//   // }
//   //
//   // Future<void> logSignUp(String method) {
//   //   return analytics.logSignUp(signUpMethod: method);
//   // }
//   //
//   // Future<void> logGoalCreated() {
//   //   return analytics.logEvent(name: 'create_goal');
//   // }
//   //
//   // Future<void> logGoalDeleted() {
//   //   return analytics.logEvent(name: 'delete_goal');
//   // }
//   //
//   // Future<void> logGoalSavedAsAchievement() {
//   //   return analytics.logEvent(name: 'goal_saved_as_achievement');
//   // }
//   //
//   // Future<void> logAchievementDeleted() {
//   //   return analytics.logEvent(name: 'delete_achievement');
//   // }
//   //
//   // Future<void> logWorkoutCreated() {
//   //   return analytics.logEvent(name: 'create_workout');
//   // }
//   //
//   // Future<void> logWorkoutSaved() {
//   //   return analytics.logEvent(name: 'save_workout');
//   // }
//   //
//   // Future<void> logWorkoutDeleted() {
//   //   return analytics.logEvent(name: 'delete_workout');
//   // }
//   //
//   // Future<void> logAddProgressOnActivity([bool useSmartSuggestions = false]) {
//   //   return analytics.logEvent(
//   //       name: 'add_progress_using_activity',
//   //       parameters: {'used_smart_suggestions': useSmartSuggestions ? 1 : 0});
//   // }
//   //
//   // Future<void> logAddProgressOnCalendar([bool useSmartSuggestions = false]) {
//   //   return analytics.logEvent(
//   //       name: 'add_progress_using_calendar',
//   //       parameters: {'used_smart_suggestions': useSmartSuggestions ? 1 : 0});
//   // }
//   //
//   // Future<void> logAddProgressOnWorkoutPlayer() {
//   //   return analytics.logEvent(name: 'add_progress_using_workout_player');
//   // }
//   //
//   // Future<void> logCompleteCalendarDay() {
//   //   return analytics.logEvent(name: 'complete_calendar_day');
//   // }
//   //
//   // Future<void> logEnableCustomWorkout() {
//   //   return analytics.logEvent(name: 'enable_custom_workout');
//   // }
//   //
//   // Future<void> logEnableGlobalWorkout() {
//   //   return analytics.logEvent(name: 'enable_global_workout');
//   // }
//   //
//   // Future<void> logDisableCustomWorkout() {
//   //   return analytics.logEvent(name: 'disable_custom_workout');
//   // }
//   //
//   // Future<void> logDisableGlobalWorkout() {
//   //   return analytics.logEvent(name: 'disable_global_workout');
//   // }
//   //
//   // Future<void> logEnterSettingsScreen() {
//   //   return analytics.setCurrentScreen(screenName: 'settings_screen');
//   // }
//   //
//   // Future<void> logEnterUserSettingsScreen() {
//   //   return analytics.setCurrentScreen(screenName: 'user_settings_screen');
//   // }
//   //
//   // Future<void> logEnterHomeScreen() {
//   //   return analytics.setCurrentScreen(screenName: 'Home');
//   // }
//   //
//   // Future<void> logChangeColorTheme(FredericColorTheme theme) {
//   //   return analytics.logEvent(
//   //       name: 'change_color_theme', parameters: {'theme': theme.name});
//   // }
// }

class UmamiAnalyticsService extends FredericAnalyticsService {
  UmamiTracker? analytics;
  bool enabled = true;

  @override
  Future<void> initialize() async {
    analytics = await createUmamiTracker(
      url: 'http://localhost:3000',
      id: '7c26e5db-eef9-4285-9d77-b88e18415e3a',
      hostname: 'io.hawkford.fredericapp',
    );

    if (kDebugMode) {
      // enabled = false;
    }
  }

  @override
  Future<void> enable() async {
    return analytics?.trackEvent(eventType: 'enable-analytics');
    enabled = true;
  }

  @override
  Future<void> disable() async {
    return analytics?.trackEvent(eventType: 'disable-analytics');
    enabled = false;
  }

  @override
  Future<void> logLogin(String method) async {
    if (!enabled) return;
    return analytics?.trackEvent(eventType: 'user-login', eventValue: method);
  }

  @override
  Future<void> logSignUp(String method) async {
    if (!enabled) return;
    return analytics?.trackEvent(eventType: 'user-signup', eventValue: method);
  }

  @override
  Future<void> logGoalCreated() async {
    if (!enabled) return;
    return analytics?.trackEvent(eventType: 'create-goal');
  }

  @override
  Future<void> logGoalDeleted() async {
    if (!enabled) return;
    return analytics?.trackEvent(eventType: 'delete-goal');
  }

  @override
  Future<void> logGoalSavedAsAchievement() async {
    if (!enabled) return;
    return analytics?.trackEvent(eventType: 'goal-saved-to-achievement');
  }

  @override
  Future<void> logAchievementDeleted() async {
    if (!enabled) return;
    return analytics?.trackEvent(eventType: 'delete-achievement');
  }

  @override
  Future<void> logWorkoutCreated([String? name]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'create-custom-workout', eventValue: name);
  }

  @override
  Future<void> logWorkoutSaved([String? name]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'update-custom-workout', eventValue: name);
  }

  @override
  Future<void> logWorkoutDeleted([String? name]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'delete-custom-workout', eventValue: name);
  }

  @override
  Future<void> logAddProgressOnActivity(
      [bool useSmartSuggestions = false]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'add-progress', eventValue: 'activity');
  }

  @override
  Future<void> logAddProgressOnCalendar(
      [bool useSmartSuggestions = false]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'add-progress', eventValue: 'calendar');
  }

  @override
  Future<void> logAddProgressOnWorkoutPlayer() async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'add-progress', eventValue: 'workout-player');
  }

  @override
  Future<void> logCompleteCalendarDay() async {
    if (!enabled) return;
    return analytics?.trackEvent(eventType: 'complete-calendar-day');
  }

  @override
  Future<void> logEnableCustomWorkout([String? name]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'enable-custom-workout', eventValue: name);
  }

  @override
  Future<void> logEnableGlobalWorkout([String? name]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'enable-global-workout', eventValue: name);
  }

  @override
  Future<void> logDisableCustomWorkout([String? name]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'disable-custom-workout', eventValue: name);
  }

  @override
  Future<void> logDisableGlobalWorkout([String? name]) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'disable-global-workout', eventValue: name);
  }

  @override
  Future<void> logEnterSettingsScreen() async {
    if (!enabled) return;
    return analytics?.trackScreenView('settings-screen');
  }

  @override
  Future<void> logEnterUserSettingsScreen() async {
    if (!enabled) return;
    return analytics?.trackScreenView('user-settings-screen');
  }

  @override
  Future<void> logChangeColorTheme(FredericColorTheme theme) async {
    if (!enabled) return;
    return analytics?.trackEvent(
        eventType: 'change-color-theme', eventValue: theme.name);
  }

  @override
  Future<void> logCurrentScreen(String screen) async {
    if (!enabled) return;
    return analytics?.trackScreenView(screen);
  }
}

class MixpanelAnalyticsService extends FredericAnalyticsService {
  Mixpanel? analytics;
  bool enabled = true;

  @override
  Future<void> initialize() async {
    analytics = await Mixpanel.init('7f9a851fefbb827181af6244147968de',
        trackAutomaticEvents: true);

    if (kDebugMode) {
      // enabled = false;
    }
  }

  @override
  Future<void> enable() async {
    return analytics?.track('enable-analytics');
    enabled = true;
  }

  @override
  Future<void> disable() async {
    return analytics?.track('disable-analytics');
    enabled = false;
  }

  @override
  Future<void> logLogin(String method) async {
    if (!enabled) return;
    return analytics?.track('user-login', properties: {'method': method});
  }

  @override
  Future<void> logSignUp(String method) async {
    if (!enabled) return;
    return analytics?.track('user-signup', properties: {'method': method});
  }

  @override
  Future<void> logGoalCreated() async {
    if (!enabled) return;
    return analytics?.track('create-goal');
  }

  @override
  Future<void> logGoalDeleted() async {
    if (!enabled) return;
    return analytics?.track('delete-goal');
  }

  @override
  Future<void> logGoalSavedAsAchievement() async {
    if (!enabled) return;
    return analytics?.track('goal-saved-to-achievement');
  }

  @override
  Future<void> logAchievementDeleted() async {
    if (!enabled) return;
    return analytics?.track('delete-achievement');
  }

  @override
  Future<void> logWorkoutCreated([String? name]) async {
    if (!enabled) return;
    return analytics
        ?.track('create-custom-workout', properties: {'name': name});
  }

  @override
  Future<void> logWorkoutSaved([String? name]) async {
    if (!enabled) return;
    return analytics
        ?.track('update-custom-workout', properties: {'name': name});
  }

  @override
  Future<void> logWorkoutDeleted([String? name]) async {
    if (!enabled) return;
    return analytics
        ?.track('delete-custom-workout', properties: {'name': name});
  }

  @override
  Future<void> logAddProgressOnActivity(
      [bool useSmartSuggestions = false]) async {
    if (!enabled) return;
    return analytics?.track('add-progress', properties: {'where': 'activity'});
  }

  @override
  Future<void> logAddProgressOnCalendar(
      [bool useSmartSuggestions = false]) async {
    if (!enabled) return;
    return analytics?.track('add-progress', properties: {'where': 'calendar'});
  }

  @override
  Future<void> logAddProgressOnWorkoutPlayer() async {
    if (!enabled) return;
    return analytics
        ?.track('add-progress', properties: {'where': 'workout-player'});
  }

  @override
  Future<void> logCompleteCalendarDay() async {
    if (!enabled) return;
    return analytics?.track('complete-calendar-day');
  }

  @override
  Future<void> logEnableCustomWorkout([String? name]) async {
    if (!enabled) return;
    return analytics
        ?.track('enable-custom-workout', properties: {'name': name});
  }

  @override
  Future<void> logEnableGlobalWorkout([String? name]) async {
    if (!enabled) return;
    return analytics
        ?.track('enable-global-workout', properties: {'name': name});
  }

  @override
  Future<void> logDisableCustomWorkout([String? name]) async {
    if (!enabled) return;
    return analytics
        ?.track('disable-custom-workout', properties: {'name': name});
  }

  @override
  Future<void> logDisableGlobalWorkout([String? name]) async {
    if (!enabled) return;
    return analytics
        ?.track('disable-global-workout', properties: {'name': name});
  }

  @override
  Future<void> logEnterSettingsScreen() async {
    if (!enabled) return;
    return analytics
        ?.track('view-page', properties: {'page': 'settings-screen'});
  }

  @override
  Future<void> logEnterUserSettingsScreen() async {
    if (!enabled) return;
    return analytics
        ?.track('view-page', properties: {'page': 'user-settings-screen'});
  }

  @override
  Future<void> logChangeColorTheme(FredericColorTheme theme) async {
    if (!enabled) return;
    return analytics
        ?.track('change-color-theme', properties: {'theme': theme.name});
  }

  @override
  Future<void> logCurrentScreen(String screen) async {
    if (!enabled) return;
    return analytics?.track('view-page', properties: {'page': screen});
  }
}
