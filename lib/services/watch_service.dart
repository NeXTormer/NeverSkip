import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';

class WatchService {
  static const MethodChannel _channel = MethodChannel('io.hawkford.frederic/watch');

  // Singleton pattern
  static final WatchService _instance = WatchService._internal();
  factory WatchService() => _instance;
  
  WatchService._internal() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Function(Map<String, dynamic>)? onDataReceived;

  Future<void> sendDataToWatch(Map<String, dynamic> data) async {
    try {
      await _channel.invokeMethod('sendDataToWatch', data);
    } on PlatformException catch (e) {
      print("Error sending data to watch: ${e.message}");
    }
  }

  // Called to sync today's workout plan to the Watch
  Future<void> syncCalendarToWatch() async {
    final user = FredericBackend.instance.userManager.state;
    final workoutManager = FredericBackend.instance.workoutManager;
    final setManager = FredericBackend.instance.setManager;

    if (user.id.isEmpty) return;

    DateTime day = DateTime.now();
    List<FredericWorkoutActivity> activitiesDueToday = [];
    
    for (var activeWorkoutPair in user.activeWorkouts.entries) {
      if (workoutManager.state.workouts[activeWorkoutPair.key] != null) {
        activitiesDueToday.addAll(workoutManager.state
            .workouts[activeWorkoutPair.key]!.activities
            .getDay(day, activeWorkoutPair.value));
      }
    }

    List<Map<String, dynamic>> activitiesData = activitiesDueToday.map((wa) {
      FredericSet? latestSet;
      final setList = setManager.sets[wa.activity.id];
      if (setList != null) {
        final latestList = setList.getLatestSets(1);
        if (latestList.isNotEmpty) latestSet = latestList.first;
      }
      
      return {
        'id': wa.activity.id,
        'name': wa.activity.name,
        'targetSets': wa.sets,
        'targetReps': wa.reps,
        'previousWeight': latestSet?.weight ?? 0.0,
        'previousReps': latestSet?.reps ?? wa.reps,
        'type': wa.activity.type.toString().split('.').last,
      };
    }).toList();

    try {
      await _channel.invokeMethod('updateApplicationContext', {'activities': activitiesData});
    } on PlatformException catch (e) {
      print("Error updating watch context: ${e.message}");
    }
  }

  Future<void> getPendingSets() async {
    try {
      await _channel.invokeMethod('getPendingSets');
    } on PlatformException catch (e) {
      print("Error getting pending sets: ${e.message}");
    }
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'receivedDataFromWatch':
        final Map<String, dynamic> data = Map<String, dynamic>.from(call.arguments);
        if (onDataReceived != null) {
          onDataReceived!(data);
        }
        break;
      case 'receivedSets':
        List<dynamic> setsData = call.arguments;
        _handleIncomingSets(setsData);
        break;
      default:
        print('Method ${call.method} not implemented');
    }
  }

  Future<void> _handleIncomingSets(List<dynamic> setsData) async {
    final activityManager = FredericBackend.instance.activityManager;
    final setManager = FredericBackend.instance.setManager;

    for (var setData in setsData) {
      if (setData is Map) {
        String activityId = setData['activityId'];
        int reps = setData['reps'];
        double weight = (setData['weight'] as num).toDouble();
        
        // Find activity
        FredericActivity? activity = activityManager.state.activities[activityId];
        if (activity != null) {
          // Use current time or decode timestamp if provided later
          FredericSet newSet = FredericSet(reps, weight, DateTime.now());
          setManager.addSet(activity, newSet);
        }
      }
    }
  }
}

