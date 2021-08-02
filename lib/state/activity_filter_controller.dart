import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';

class ActivityFilterController with ChangeNotifier {
  ActivityFilterController() {
    _types[FredericActivityType.Weighted] = true;
    _types[FredericActivityType.Calisthenics] = true;
    _types[FredericActivityType.Stretch] = true;

    _muscleGroups[FredericActivityMuscleGroup.Arms] = true;
    _muscleGroups[FredericActivityMuscleGroup.Chest] = true;
    _muscleGroups[FredericActivityMuscleGroup.Back] = true;
    _muscleGroups[FredericActivityMuscleGroup.Core] = true;
    _muscleGroups[FredericActivityMuscleGroup.Legs] = true;
  }

  HashMap<FredericActivityMuscleGroup, bool> _muscleGroups =
      HashMap<FredericActivityMuscleGroup, bool>();
  HashMap<FredericActivityType, bool> _types =
      HashMap<FredericActivityType, bool>();
  String _searchText = '';

  bool get weighted => _types[FredericActivityType.Weighted] ?? false;
  bool get calisthenics => _types[FredericActivityType.Calisthenics] ?? false;
  bool get stretch => _types[FredericActivityType.Stretch] ?? false;
  bool get arms => _muscleGroups[FredericActivityMuscleGroup.Arms] ?? false;
  bool get chest => _muscleGroups[FredericActivityMuscleGroup.Chest] ?? false;
  bool get back => _muscleGroups[FredericActivityMuscleGroup.Back] ?? false;
  bool get abs => _muscleGroups[FredericActivityMuscleGroup.Core] ?? false;
  bool get legs => _muscleGroups[FredericActivityMuscleGroup.Legs] ?? false;

  bool get allTypes => (weighted == calisthenics) == stretch;
  bool get allMuscles => ((arms == chest) == (back == abs)) == legs;

  String get searchText => _searchText;

  HashMap<FredericActivityMuscleGroup, bool> get muscleGroups => _muscleGroups;
  HashMap<FredericActivityType, bool> get types => _types;

  set weighted(bool value) {
    _types[FredericActivityType.Weighted] = value;
    notifyListeners();
  }

  set calisthenics(bool value) {
    _types[FredericActivityType.Calisthenics] = value;
    notifyListeners();
  }

  set stretch(bool value) {
    _types[FredericActivityType.Stretch] = value;
    notifyListeners();
  }

  set arms(bool value) {
    _muscleGroups[FredericActivityMuscleGroup.Arms] = value;
    notifyListeners();
  }

  set legs(bool value) {
    _muscleGroups[FredericActivityMuscleGroup.Legs] = value;
    notifyListeners();
  }

  set abs(bool value) {
    _muscleGroups[FredericActivityMuscleGroup.Core] = value;
    notifyListeners();
  }

  set chest(bool value) {
    _muscleGroups[FredericActivityMuscleGroup.Chest] = value;
    notifyListeners();
  }

  set back(bool value) {
    _muscleGroups[FredericActivityMuscleGroup.Back] = value;
    notifyListeners();
  }

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }
}
