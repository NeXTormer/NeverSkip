import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';

///
/// Manages all Activities using the Bloc Pattern
///
class FredericActivityManager
    extends Bloc<FredericActivityEvent, FredericActivityListData> {
  FredericActivityManager()
      : super(FredericActivityListData(
            <String>[], HashMap<String, FredericActivity>())) {
    on<FredericActivityEvent>(_onEvent);
  }

  late final FredericDataInterface<FredericActivity> dataInterface;

  HashMap<String, FredericActivity> _activities =
      HashMap<String, FredericActivity>();

  bool _canFullReload = true;

  FredericActivity? operator [](String value) {
    return _activities[value];
  }

  Iterable<FredericActivity> get allActivities => state.activities.values;

  void setDataInterface(FredericDataInterface<FredericActivity> interface) =>
      dataInterface = interface;

  ///
  /// (Re)Loads all activities from the database
  ///
  Future<void> reload([bool fullReloadFromDB = false]) async {
    List<String> changed = <String>[];
    _activities.clear();
    List<FredericActivity> list =
        await (fullReloadFromDB ? dataInterface.reload() : dataInterface.get());
    for (FredericActivity activity in list) {
      _activities[activity.id] = activity;
      changed.add(activity.id);
    }
    add(FredericActivityEvent(changed));
    return;
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

  FredericActivity getActivity(String id) {
    if (_activities.containsKey(id)) return _activities[id]!;
    return FredericActivity.noSuchActivity(id);
  }

  Future<void> deleteActivity(FredericActivity activity) async {
    if (activity.canEdit) {
      _activities.remove(activity.id);
      await dataInterface.delete(activity);
      add(FredericActivityEvent([activity.id]));
    }
  }

  FutureOr<void> _onEvent(FredericActivityEvent event,
      Emitter<FredericActivityListData> emit) async {
    if (event is FredericActivityUpdateEvent) {
      await dataInterface.update(event.updated);
      _activities[event.updated.id] = event.updated;
      emit(FredericActivityListData([event.updated.id], _activities));
    } else if (event is FredericActivityCreateEvent) {
      FredericActivity newActivity =
          await dataInterface.create(event.newActivity);
      _activities[newActivity.id] = newActivity;
      emit(FredericActivityListData([newActivity.id], _activities));
    } else {
      emit(FredericActivityListData(event.changed, _activities));
    }
  }

  @override
  void onTransition(
      Transition<FredericActivityEvent, FredericActivityListData> transition) {
    // print('ActivityManager========================================');
    // print(transition);
    // print('Activities:');
    // print(activities.length);
    // print('Changes:');
    // print(state.changed.toString());
    // print('ActivityManager========================================');
    super.onTransition(transition);
  }
}

class FredericActivityEvent {
  FredericActivityEvent(this.changed);
  List<String> changed;
}

class FredericActivityUpdateEvent extends FredericActivityEvent {
  FredericActivityUpdateEvent(this.updated) : super(<String>[updated.id]);

  FredericActivity updated;
}

class FredericActivityCreateEvent extends FredericActivityEvent {
  FredericActivityCreateEvent(this.newActivity)
      : super(<String>[newActivity.id]);

  FredericActivity newActivity;
}
