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
  FredericActivityManager({required this.dataInterface})
      : super(FredericActivityListData(
            <String>[], HashMap<String, FredericActivity>()));

  final FredericDataInterface<FredericActivity> dataInterface;

  HashMap<String, FredericActivity> _activities =
      HashMap<String, FredericActivity>();

  FredericActivity? operator [](String value) {
    return state.activities[value];
  }

  Iterable<FredericActivity> get allActivities => state.activities.values;

  ///
  /// (Re)Loads all activities from the database
  ///
  Future<void> reload() async {
    List<String> changed = <String>[];
    _activities.clear();
    List<FredericActivity> list = await dataInterface.get();
    for (FredericActivity activity in list) {
      _activities[activity.id] = activity;
      changed.add(activity.id);
    }
    add(FredericActivityEvent(changed));
    return;
  }

  ///
  /// Returns an Activity using its id. Loads the Activity if needed.
  ///
  Future<FredericActivity> getActivity(String id) async {
    if (_activities.containsKey(id)) return _activities[id]!;
    return FredericActivity.noSuchActivity(id);
  }

  @override
  Stream<FredericActivityListData> mapEventToState(
      FredericActivityEvent event) async* {
    if (event is FredericActivityUpdateEvent) {
      await dataInterface.update(event.updated);
      _activities[event.updated.id] = event.updated;
      yield FredericActivityListData([event.updated.id], _activities);
    } else if (event is FredericActivityCreateEvent) {
      FredericActivity newActivity =
          await dataInterface.create(event.newActivity);
      _activities[newActivity.id] = newActivity;
      yield FredericActivityListData([newActivity.id], _activities);
    } else {
      yield FredericActivityListData(event.changed, _activities);
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
