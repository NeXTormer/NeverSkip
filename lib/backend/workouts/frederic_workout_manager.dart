import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';

///
/// Manages all Workouts. Only one instance of this should exist. Instantiated in
/// [FredericBackend].
///
class FredericWorkoutManager
    extends Bloc<FredericWorkoutEvent, FredericWorkoutListData> {
  FredericWorkoutManager()
      : _workouts = HashMap<String, FredericWorkout>(),
        super(FredericWorkoutListData(
            HashMap<String, FredericWorkout>(), <String>[]));

  final CollectionReference _workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');

  HashMap<String, FredericWorkout> _workouts;

  FredericWorkout? operator [](String value) {
    return _workouts[value];
  }

  HashMap<String, FredericWorkout> get workouts => state.workouts;

  Future<void> reload() async {
    QuerySnapshot<Object?> global =
        await _workoutsCollection.where('owner', isEqualTo: 'global').get();
    QuerySnapshot<Object?> private = await _workoutsCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    List<String> changed = <String>[];
    _workouts.clear();

    for (int i = 0; i < global.docs.length; i++) {
      FredericWorkout workout = FredericWorkout(global.docs[i], this);
      await workout.loadActivities();
      _workouts[global.docs[i].id] = workout;

      changed.add(global.docs[i].id);
    }
    for (int i = 0; i < private.docs.length; i++) {
      FredericWorkout workout = FredericWorkout(private.docs[i], this);
      await workout.loadActivities();
      _workouts[private.docs[i].id] = workout;
      changed.add(private.docs[i].id);
    }

    add(FredericWorkoutEvent(changed));

    return;
  }

  @override
  Stream<FredericWorkoutListData> mapEventToState(
      FredericWorkoutEvent event) async* {
    if (event is FredericWorkoutUpdateEvent) {
      yield FredericWorkoutListData(_workouts, event.changed);
    } else if (event is FredericWorkoutCreateEvent) {
      _workouts[event.workout.workoutID] = event.workout;
      yield FredericWorkoutListData(_workouts, event.changed);
    } else if (event is FredericWorkoutDeleteEvent) {
      if (FredericBackend.instance.userManager.state.activeWorkouts
          .contains(event.workout.workoutID)) {
        List<String> activeWorkouts =
            FredericBackend.instance.userManager.state.activeWorkouts;
        activeWorkouts.remove(event.workout.workoutID);
        FredericBackend.instance.userManager.state.activeWorkouts =
            activeWorkouts;
      }
      _workouts[event.workout.workoutID]?.delete();
      _workouts.remove(event.workout.workoutID);
      yield FredericWorkoutListData(_workouts, event.changed);
    } else if (event is FredericWorkoutEvent) {
      yield FredericWorkoutListData(_workouts, event.changed);
    }
  }
}

class FredericWorkoutEvent {
  FredericWorkoutEvent(this.changed);
  List<String> changed;
}

class FredericWorkoutUpdateEvent extends FredericWorkoutEvent {
  FredericWorkoutUpdateEvent(String updated) : super([updated]);
}

class FredericWorkoutCreateEvent extends FredericWorkoutEvent {
  FredericWorkoutCreateEvent(this.workout) : super([workout.workoutID]);
  FredericWorkout workout;
}

class FredericWorkoutDeleteEvent extends FredericWorkoutEvent {
  FredericWorkoutDeleteEvent(this.workout) : super([workout.workoutID]);
  FredericWorkout workout;
}

class FredericWorkoutListData {
  FredericWorkoutListData(this.workouts, this.changed);

  final HashMap<String, FredericWorkout> workouts;
  final List<String> changed;

  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => changed.hashCode;
}
