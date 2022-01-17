import 'dart:collection';

import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';

class TestActivityDataInterface
    extends FredericDataInterface<FredericActivity> {
  HashMap<String, FredericActivity> database =
      HashMap<String, FredericActivity>();
  int index = 0;
  void initData() {
    addActivity('Werner', FredericActivityType.Weighted,
        [FredericActivityMuscleGroup.Arms]);
    addActivity('Peter', FredericActivityType.Weighted,
        [FredericActivityMuscleGroup.Arms]);
    addActivity('Herbert', FredericActivityType.Calisthenics,
        [FredericActivityMuscleGroup.Arms]);
    addActivity('Edeltraut', FredericActivityType.Weighted,
        [FredericActivityMuscleGroup.Arms]);
    addActivity('Farid', FredericActivityType.Weighted,
        [FredericActivityMuscleGroup.Arms]);
    addActivity('Hubert', FredericActivityType.Calisthenics,
        [FredericActivityMuscleGroup.Arms, FredericActivityMuscleGroup.Chest]);
    addActivity('Hoast', FredericActivityType.Calisthenics, []);
  }

  void addActivity(String name, FredericActivityType type,
      List<FredericActivityMuscleGroup> mg) {
    createFromMap({
      'name': name,
      'description': 'Activity for unit tests',
      'type': FredericActivity.parseTypeToString(type),
      'musclegroup': FredericActivity.parseMuscleGroupListToStringList(mg)
    });
  }

  @override
  Future<FredericActivity> create(FredericActivity object) {
    return createFromMap(object.toMap());
  }

  @override
  Future<FredericActivity> createFromMap(Map<String, dynamic> data) async {
    var activity = FredericActivity.fromMap('X$index', data);
    database['X$index'] = activity;
    index++;
    return activity;
  }

  @override
  Future<void> delete(FredericActivity object) async {
    database.remove(object.id);
  }

  @override
  Future<List<FredericActivity>> get() async {
    return database.values.toList();
  }

  @override
  Future<FredericActivity> update(FredericActivity object) async {
    database[object.id] = object;
    return object;
  }

  @override
  Future<List<FredericActivity>> reload() {
    // TODO: implement reload
    throw UnimplementedError();
  }
}
