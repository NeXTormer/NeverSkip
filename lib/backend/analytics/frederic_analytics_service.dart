import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:frederic/theme/frederic_theme.dart';

abstract class FredericAnalyticsService {
  Future<void> initialize();

  Future<void> enable();

  Future<void> disable();

  Future<void> logCurrentScreen(String screen);

  Future<void> logLogin(String method);

  Future<void> logSignUp(String method);

  Future<void> logPurchaseApp();

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

  Future<void> logChangeColorTheme(FredericColorTheme theme);
}

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

    try {
      await dio?.get('/');
    } catch (e) {
      enabled = false;
      print(e);
      FredericProfiler.log(
          'cant reach analytics server, disabling analytics service.');
    }

    if (kDebugMode) {
      enabled = false;
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

    FredericProfiler.log("sending analytics: $payload");

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
            '${PlatformDispatcher.instance.displays.first.size.width.toInt()}x${PlatformDispatcher.instance.displays.first.size.height.toInt()}',
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
  Future<void> logChangeColorTheme(FredericColorTheme theme) async {
    if (!enabled) return;
    return trackEvent(type: 'change-color-theme', data: theme.name);
  }

  @override
  Future<void> logCurrentScreen(String screen) async {
    if (!enabled) return;
    return trackScreen(screen);
  }

  @override
  Future<void> logPurchaseApp() async {
    if (!enabled) return;
    return trackEvent(type: 'purchased-app');
  }
}
