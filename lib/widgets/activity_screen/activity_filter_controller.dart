import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';

class ActivityFilterController with ChangeNotifier {
  ActivityFilterController() {
    _muscleGroups = HashMap<FredericActivityMuscleGroup, bool?>();
    _types = HashMap<FredericActivityType, bool?>();

    _types![FredericActivityType.Weighted] = true;
    _types![FredericActivityType.Calisthenics] = true;
    _types![FredericActivityType.Stretch] = true;

    _muscleGroups![FredericActivityMuscleGroup.Arms] = true;
    _muscleGroups![FredericActivityMuscleGroup.Chest] = true;
    _muscleGroups![FredericActivityMuscleGroup.Back] = true;
    _muscleGroups![FredericActivityMuscleGroup.Abs] = true;
    _muscleGroups![FredericActivityMuscleGroup.Legs] = true;

    _searchText = '';
  }

  HashMap<FredericActivityMuscleGroup, bool?>? _muscleGroups;
  HashMap<FredericActivityType, bool?>? _types;
  String? _searchText;

  bool? get weighted => _types![FredericActivityType.Weighted];
  bool? get calisthenics => _types![FredericActivityType.Calisthenics];
  bool? get stretch => _types![FredericActivityType.Stretch];
  bool? get arms => _muscleGroups![FredericActivityMuscleGroup.Arms];
  bool? get chest => _muscleGroups![FredericActivityMuscleGroup.Chest];
  bool? get back => _muscleGroups![FredericActivityMuscleGroup.Back];
  bool? get abs => _muscleGroups![FredericActivityMuscleGroup.Abs];
  bool? get legs => _muscleGroups![FredericActivityMuscleGroup.Legs];

  bool get allTypes => (weighted == calisthenics) == stretch;
  bool get allMuscles => ((arms == chest) == (back == abs)) == legs;

  String? get searchText => _searchText;

  HashMap<FredericActivityMuscleGroup, bool?>? get muscleGroups => _muscleGroups;
  HashMap<FredericActivityType, bool?>? get types => _types;

  set weighted(bool? value) {
    _types![FredericActivityType.Weighted] = value;
    notifyListeners();
  }

  set calisthenics(bool? value) {
    _types![FredericActivityType.Calisthenics] = value;
    notifyListeners();
  }

  set stretch(bool? value) {
    _types![FredericActivityType.Stretch] = value;
    notifyListeners();
  }

  set arms(bool? value) {
    _muscleGroups![FredericActivityMuscleGroup.Arms] = value;
    notifyListeners();
  }

  set legs(bool? value) {
    _muscleGroups![FredericActivityMuscleGroup.Legs] = value;
    notifyListeners();
  }

  set abs(bool? value) {
    _muscleGroups![FredericActivityMuscleGroup.Abs] = value;
    notifyListeners();
  }

  set chest(bool? value) {
    _muscleGroups![FredericActivityMuscleGroup.Chest] = value;
    notifyListeners();
  }

  set back(bool? value) {
    _muscleGroups![FredericActivityMuscleGroup.Back] = value;
    notifyListeners();
  }

  set searchText(String? value) {
    _searchText = value;
    notifyListeners();
  }
}
