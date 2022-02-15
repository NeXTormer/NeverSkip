import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';

///
/// Manages all Workouts. Only one instance of this should exist. Instantiated in
/// [FredericBackend].
///
class FredericWorkoutManager
    extends Bloc<FredericWorkoutEvent, FredericWorkoutListData> {
  FredericWorkoutManager({required this.activityManager})
      : _workouts = HashMap<String, FredericWorkout>(),
        super(FredericWorkoutListData(
            HashMap<String, FredericWorkout>(), <String>[])) {
    on<FredericWorkoutEvent>(_onEvent);
  }

  HashMap<String, FredericWorkout> _workouts;
  bool _canFullReload = true;

  late final FredericDataInterface<FredericWorkout> dataInterface;
  final FredericActivityManager activityManager;

  FredericWorkout? operator [](String value) {
    return _workouts[value];
  }

  HashMap<String, FredericWorkout> get workouts => state.workouts;

  void setDataInterface(FredericDataInterface<FredericWorkout> interface) =>
      dataInterface = interface;

  Future<void> reload([bool fullReloadFromDB = false]) async {
    List<FredericWorkout> workouts =
        await (fullReloadFromDB ? dataInterface.reload() : dataInterface.get());
    List<String> changed = <String>[];

    _workouts.clear();
    for (var workout in workouts) {
      changed.add(workout.id);
      workout.loadActivities(activityManager);
      workout.onUpdate = updateWorkoutInDB;
      _workouts[workout.id] = workout;
    }

    add(FredericWorkoutEvent(changed));
  }

  Future<void> triggerManualFullReload() async {
    if (_canFullReload) {
      _canFullReload = false;
      Timer(Duration(seconds: 5), () {
        _canFullReload = true;
      });
      return reload(true);
    } else {
      return Future.delayed(Duration(milliseconds: 50));
    }
  }

  void updateWorkoutInDB(FredericWorkout workout) {
    dataInterface.update(workout);
    add(FredericWorkoutUpdateEvent(workout.id));
  }

  Future<void> _deleteWorkout(FredericWorkout workout) {
    if (FredericBackend.instance.userManager.state.activeWorkouts
        .contains(workout.id)) {
      FredericBackend.instance.userManager.removeActiveWorkout(workout.id);
    }
    _workouts.remove(workout.id);
    return dataInterface.delete(workout);
  }

  FutureOr<void> _onEvent(
      FredericWorkoutEvent event, Emitter<FredericWorkoutListData> emit) async {
    if (event is FredericWorkoutUpdateEvent) {
      emit(FredericWorkoutListData(_workouts, event.changed));
    } else if (event is FredericWorkoutCreateEvent) {
      var workout = await dataInterface.create(event.workout);
      workout.onUpdate = updateWorkoutInDB;
      _workouts[workout.id] = workout;
      emit(FredericWorkoutListData(_workouts, event.changed));
    } else if (event is FredericWorkoutDeleteEvent) {
      _deleteWorkout(event.workout);
      emit(FredericWorkoutListData(_workouts, event.changed));
    } else {
      emit(FredericWorkoutListData(_workouts, event.changed));
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
  FredericWorkoutCreateEvent(this.workout) : super([workout.id]);
  FredericWorkout workout;
}

class FredericWorkoutDeleteEvent extends FredericWorkoutEvent {
  FredericWorkoutDeleteEvent(this.workout) : super([workout.id]);
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
