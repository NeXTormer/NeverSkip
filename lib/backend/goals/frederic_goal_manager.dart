import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/frederic_backend.dart';
import 'package:frederic/backend/goals/frederic_goal_list_data.dart';

import 'frederic_goal.dart';

class FredericGoalManager
    extends Bloc<FredericGoalEvent, FredericGoalListData> {
  FredericGoalManager()
      : super(
            FredericGoalListData(<String>[], HashMap<String, FredericGoal>())) {
    on<FredericGoalEvent>(_onEvent);
  }

  late final FredericDataInterface<FredericGoal> dataInterface;

  void setDataInterface(FredericDataInterface<FredericGoal> interface) =>
      dataInterface = interface;

  HashMap<String, FredericGoal> _goals = HashMap<String, FredericGoal>();

  FredericGoal? operator [](String value) {
    return _goals[value];
  }

  Future<void> reload([bool fullReloadFromDB = true]) async {
    List<String> changed = <String>[];
    _goals.clear();
    List<FredericGoal> list =
        await (fullReloadFromDB ? dataInterface.reload() : dataInterface.get());
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
      if (_goals.containsKey(event.updatedGoal.id)) {
        _goals[event.updatedGoal.id] = event.updatedGoal;
      }
      await dataInterface.update(event.updatedGoal);
      emit(FredericGoalListData(event.changed, _goals));
    } else if (event is FredericGoalCreateEvent) {
      final newGoalFromDatabase = await dataInterface.create(event.newGoal);
      _goals[event.newGoal.id] = newGoalFromDatabase;
      emit(FredericGoalListData(event.changed, _goals));
      FredericBackend.instance.analytics.logGoalCreated();
    } else if (event is FredericGoalDeleteEvent) {
      _goals.remove(event.goal.id);
      await dataInterface.delete(event.goal);
      emit(FredericGoalListData(event.changed, _goals));
      FredericBackend.instance.analytics.logGoalDeleted();
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
