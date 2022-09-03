import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/goals/frederic_goal_list_data.dart';

import 'frederic_goal.dart';

class FredericGoalManager
    extends Bloc<FredericGoalEvent, FredericGoalListData> {
  FredericGoalManager()
      : super(
            FredericGoalListData(<String>[], HashMap<String, FredericGoal>())) {
    on<FredericGoalEvent>(_onEvent);
  }

  late final FredericDataInterface<FredericGoal> _dataInterface;

  void setDataInterface(FredericDataInterface<FredericGoal> interface) =>
      _dataInterface = interface;

  HashMap<String, FredericGoal> _goals = HashMap<String, FredericGoal>();

  FredericGoal? operator [](String value) {
    return _goals[value];
  }

  Future<void> reload([bool fullReloadFromDB = true]) async {
    List<String> changed = <String>[];
    _goals.clear();
    List<FredericGoal> list = await (fullReloadFromDB
        ? _dataInterface.reload()
        : _dataInterface.get());
    for (FredericGoal goal in list) {
      _goals[goal.id] = goal;
      changed.add(goal.id);
    }
    add(FredericGoalEvent(changed));
    return;
  }

  //TODO: maybe add timeout function
  Future<void> triggerManualFullReload() async {
    return reload(true);
  }

  FutureOr<void> _onEvent(
      FredericGoalEvent event, Emitter<FredericGoalListData> emit) async {
    if (event is FredericGoalUpdateEvent) {
      _goals[event.updatedGoal.id] = event.updatedGoal;
      await _dataInterface.update(event.updatedGoal);
      emit(FredericGoalListData(event.changed, _goals));
    } else if (event is FredericGoalCreateEvent) {
      _goals[event.newGoal.id] = event.newGoal;
      await _dataInterface.create(event.newGoal);
      emit(FredericGoalListData(event.changed, _goals));
    } else if (event is FredericGoalDeleteEvent) {
      _goals.remove(event.goal.id);
      await _dataInterface.delete(event.goal);
      emit(FredericGoalListData(event.changed, _goals));
    } else {
      emit(FredericGoalListData(event.changed, _goals));
    }
  }
}

class FredericGoalEvent {
  FredericGoalEvent(this.changed);
  List<String> changed;
}

class FredericGoalUpdateEvent extends FredericGoalEvent {
  FredericGoalUpdateEvent(this.updatedGoal) : super([updatedGoal.id]);
  FredericGoal updatedGoal;
}

class FredericGoalCreateEvent extends FredericGoalEvent {
  FredericGoalCreateEvent(this.newGoal) : super([newGoal.id]);
  FredericGoal newGoal;
}

class FredericGoalDeleteEvent extends FredericGoalEvent {
  FredericGoalDeleteEvent(this.goal) : super([goal.id]);
  FredericGoal goal;
}
