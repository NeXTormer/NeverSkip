import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frederic/theme/frederic_theme.dart';

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
  Dio? dio;
  String trackingID = '7ad92f04-e9c1-4044-914e-a0a55946de40';
  bool enabled = true;

  @override
  Future<void> initialize() async {
    print('Initializing Umami Analytics Service');

    String userAgent =
        'NeverSkipFitness/1.0 (${Platform.operatingSystem == 'android' ? 'Android' : 'iOS'} 1; Google Pixel 1) Dart/1.0 (dart:io)';

    print('User Agent: $userAgent');

    dio = Dio(BaseOptions(
        baseUrl: 'https://analytics.neverskipfitness.com',
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'User-Agent': userAgent
        }));

    if (kDebugMode) {
      // enabled = false;
    }
  }

  Future<void> trackEvent({required String type, String? data}) async {
    if (!enabled) return;
    final payload = {
      "payload": {
        "hostname": "app.neverskipfitness.com",
        "language": Platform.localeName,
        "referrer": "",
        "screen": "1920x1080",
        "website": trackingID,
        "name": data == null ? '$type' : '$type-$data'
      },
      "type": "event"
    };

    print("Analytics: $payload");

    try {
      dio?.post('/api/send', data: payload);
    } catch (e) {
      print(e);
    }
  }

  Future<void> trackScreen(String name) async {
    if (!enabled) return;

    final payload = {
      "payload": {
        "hostname": "app.neverskipfitness.com",
        "referrer": "",
        "language": Platform.localeName,
        "screen":
            '${MediaQueryData.fromView(WidgetsBinding.instance.window).size.width.toInt()}x${MediaQueryData.fromView(WidgetsBinding.instance.window).size.height.toInt()}',
        "title": name.split('/').last,
        "url": "/" + name,
        "website": trackingID
      },
      "type": "event"
    };

    print("Analytics: $payload");

    try {
      dio?.post('/api/send', data: payload);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> enable() async {
    enabled = true;
    return trackEvent(type: 'enable-analytics');
  }

  @override
  Future<void> disable() async {
    enabled = false;
    return trackEvent(type: 'disable-analytics');
  }

  @override
  Future<void> logLogin(String method) async {
    if (!enabled) return;
    return trackEvent(type: 'user-login', data: method);
  }

  @override
  Future<void> logSignUp(String method) async {
    if (!enabled) return;
    return trackEvent(type: 'user-signup', data: method);
  }

  @override
  Future<void> logGoalCreated() async {
    if (!enabled) return;
    return trackEvent(type: 'create-goal');
  }

  @override
  Future<void> logGoalDeleted() async {
    if (!enabled) return;
    return trackEvent(type: 'delete-goal');
  }

  @override
  Future<void> logGoalSavedAsAchievement() async {
    if (!enabled) return;
    return trackEvent(type: 'goal-saved-to-achievement');
  }

  @override
  Future<void> logAchievementDeleted() async {
    if (!enabled) return;
    return trackEvent(type: 'delete-achievement');
  }

  @override
  Future<void> logWorkoutCreated([String? name]) async {
    if (!enabled) return;
    return trackEvent(type: 'create-custom-workout');
  }

  @override
  Future<void> logWorkoutSaved([String? name]) async {
    if (!enabled) return;
    return trackEvent(type: 'update-custom-workout');
  }

  @override
  Future<void> logWorkoutDeleted([String? name]) async {
    if (!enabled) return;
    return trackEvent(type: 'delete-custom-workout');
  }

  @override
  Future<void> logAddProgressOnActivity(
      [bool useSmartSuggestions = false]) async {
    if (!enabled) return;
    return trackEvent(type: 'add-progress', data: 'activity');
  }

  @override
  Future<void> logAddProgressOnCalendar(
      [bool useSmartSuggestions = false]) async {
    if (!enabled) return;
    return trackEvent(type: 'add-progress', data: 'calendar');
  }

  @override
  Future<void> logAddProgressOnWorkoutPlayer() async {
    if (!enabled) return;
    return trackEvent(type: 'add-progress', data: 'workout-player');
  }

  @override
  Future<void> logCompleteCalendarDay() async {
    if (!enabled) return;
    return trackEvent(type: 'complete-calendar-day');
  }

  @override
  Future<void> logEnableCustomWorkout([String? name]) async {
    if (!enabled) return;
    return trackEvent(type: 'enable-custom-workout');
  }

  @override
  Future<void> logEnableGlobalWorkout([String? name]) async {
    if (!enabled) return;
    return trackEvent(type: 'enable-global-workout');
  }

  @override
  Future<void> logDisableCustomWorkout([String? name]) async {
    if (!enabled) return;
    return trackEvent(type: 'disable-custom-workout');
  }

  @override
  Future<void> logDisableGlobalWorkout([String? name]) async {
    if (!enabled) return;
    return trackEvent(type: 'disable-global-workout');
  }

  @override
  Future<void> logEnterSettingsScreen() async {
    if (!enabled) return;
    return trackScreen('settings-screen');
  }

  @override
  Future<void> logEnterUserSettingsScreen() async {
    if (!enabled) return;
    return trackScreen('user-settings-screen');
  }

  @override
  Future<void> logChangeColorTheme(FredericColorTheme theme) async {
    if (!enabled) return;
    return trackEvent(type: 'change-color-theme', data: theme.name);
  }

  @override
  Future<void> logCurrentScreen(String screen) async {
    if (!enabled) return;
    return trackScreen(screen);
  }
}
