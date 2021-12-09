import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/admin_panel/data_table_element.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/state/activity_filter_controller.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

///
/// Represents a single Activity.
/// Changes made using the classes properties are automatically updated in the
/// database and on all listeners of the ActivityManager-Bloc.
/// Setters only work on Proper activities.
///
class FredericActivity implements DataTableElement<FredericActivity> {
  FredericActivity(DocumentSnapshot<Object?> snapshot)
      : activityID = snapshot.id {
    var data = (snapshot as DocumentSnapshot<Map<String, dynamic>?>).data();
    if (data == null) return;

    _name = data['name'];
    _description = data['description'];
    _image = data['image'];
    _owner = data['owner'];
    _recommendedReps = data['recommendedreps'];
    _recommendedSets = data['recommendedsets'];
    _type = parseTypeFromString(data['type']);

    List<dynamic>? muscleGroups = data['musclegroup'];
    muscleGroups?.forEach((element) {
      if (element is String)
        _muscleGroups.add(parseSingleMuscleGroupFromString(element));
    });
  }

  ///
  /// Constructs an empty Activity, used for creating a new Activity
  ///
  FredericActivity.create()
      : activityID = 'new',
        _name = 'New activity',
        _description = '',
        _image =
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fdumbbell.png?alt=media&token=89899620-f4b0-4624-bd07-e06c76c113fe';

  ///
  /// Constructs an Activity Template, used for creating a new Activity
  ///
  FredericActivity.template()
      : activityID = 'template',
        _image =
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fdumbbell.png?alt=media&token=89899620-f4b0-4624-bd07-e06c76c113fe';

  ///
  /// Returns an existing Activity using the provided ID. If the activity
  /// does not exist, an empty Activity is returned
  ///
  factory FredericActivity.fromID(String id) {
    return FredericBackend.instance.activityManager[id] ??
        FredericActivity.template();
  }

  ///
  /// Creates a new activity (only locally)
  /// Use this activity to push a FredericActivityCreateEvent to the
  /// ActivityManager
  ///
  FredericActivity.make(
      {required String name,
      required String description,
      required String image,
      required int recommendedReps,
      required int recommendedSets,
      required List<FredericActivityMuscleGroup> muscleGroups,
      required FredericActivityType type})
      : activityID = 'new-activity',
        _name = name,
        _description = description,
        _image = image,
        _recommendedReps = recommendedReps,
        _recommendedSets = recommendedSets,
        _muscleGroups = muscleGroups,
        _type = type;

  final String activityID;

  String? _name;
  String? _description;
  String? _image;
  String? _owner;
  int? _recommendedSets;
  int? _recommendedReps;

  FredericActivityType _type = FredericActivityType.None;

  List<FredericActivityMuscleGroup> _muscleGroups =
      <FredericActivityMuscleGroup>[];

  String get name => _name ?? '';
  String get description => _description ?? '';
  String get image => _image ?? 'https://via.placeholder.com/64x64?text=x';
  String get owner => _owner ?? 'No owner';
  int get recommendedReps => _recommendedReps ?? 1;
  int get recommendedSets => _recommendedSets ?? 1;
  bool get isNotLoaded => _name == null;
  bool get isEmpty => activityID == '';

  /// A proper activity is stored in the DB and has a valid [activityID]
  bool get isProper => activityID.length > 16;

  bool get isGlobalActivity => _owner == 'global';

  List<FredericActivityMuscleGroup> get muscleGroups => _muscleGroups;
  FredericActivityType get type => _type;

  String get progressUnit {
    if (_type == FredericActivityType.Weighted) return 'kg';
    if (_type == FredericActivityType.Calisthenics) return 'reps';
    if (_type == FredericActivityType.Stretch) return 's';
    return '';
  }

  set name(String value) {
    if (isProper && value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'name': value});
      _name = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  set description(String value) {
    if (isProper && value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'description': value});
      _description = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  set image(String value) {
    if (isProper && value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'image': value});
      _image = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  set type(FredericActivityType value) {
    if (isProper) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'type': parseTypeToString(type)});
      _type = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  set muscleGroups(List<FredericActivityMuscleGroup> value) {
    if (isProper) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'musclegroup': parseMuscleGroupListToStringList(value)});
      _muscleGroups = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  set recommendedReps(int value) {
    if (isProper && value >= 0) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'recommendedreps': value});
      _recommendedReps = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  set recommendedSets(int value) {
    if (isProper && value >= 0) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'recommendedsets': value});
      _recommendedSets = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  bool matchFilterController(ActivityFilterController controller) {
    bool match = false;
    if (!controller.types[_type]!) return false;
    for (var value in controller.muscleGroups.entries) {
      if (value.value) {
        if (_muscleGroups.contains(value.key)) match = true;
      }
    }
    if (controller.muscleGroups.entries.isEmpty) match = true;
    if (match) {
      if (controller.searchText == '') {
        return true;
      } else {
        if (name.toLowerCase().contains(controller.searchText.toLowerCase())) {
          return true;
        } else
          return false;
      }
    }
    return false;
  }

  static FredericActivityType parseTypeFromString(String? typeString) {
    if (typeString == 'weighted') return FredericActivityType.Weighted;
    if (typeString == null) return FredericActivityType.Weighted;
    if (typeString == 'cali') return FredericActivityType.Calisthenics;
    if (typeString == 'stretch') return FredericActivityType.Stretch;
    return FredericActivityType.Weighted;
  }

  static String parseTypeToString(FredericActivityType type) {
    switch (type) {
      case FredericActivityType.Weighted:
        return 'weighted';
      case FredericActivityType.Calisthenics:
        return 'cali';
      case FredericActivityType.Stretch:
        return 'stretch';
      default:
        return '';
    }
  }

  static List<FredericActivityMuscleGroup> parseMuscleGroupListFromStringList(
      List<String> muscleGroupsStrings) {
    List<FredericActivityMuscleGroup> list = <FredericActivityMuscleGroup>[];
    for (int i = 0; i < muscleGroupsStrings.length; i++) {
      list.add(parseSingleMuscleGroupFromString(muscleGroupsStrings[i]));
    }
    return list;
  }

  static List<String> parseMuscleGroupListToStringList(
      List<FredericActivityMuscleGroup> groupList) {
    List<String> strings = <String>[];
    for (int i = 0; i < groupList.length; i++) {
      strings.add(parseSingleMuscleGroupToString(groupList[i]));
    }
    return strings;
  }

  static FredericActivityMuscleGroup parseSingleMuscleGroupFromString(
      String muscleGroup) {
    switch (muscleGroup) {
      case 'arms':
        return FredericActivityMuscleGroup.Arms;
      case 'chest':
        return FredericActivityMuscleGroup.Chest;
      case 'back':
        return FredericActivityMuscleGroup.Back;
      case 'legs':
        return FredericActivityMuscleGroup.Legs;
      case 'core':
        return FredericActivityMuscleGroup.Core;
      default:
        return FredericActivityMuscleGroup.None;
    }
  }

  static String parseSingleMuscleGroupToString(
      FredericActivityMuscleGroup group) {
    switch (group) {
      case FredericActivityMuscleGroup.Arms:
        return 'arms';
      case FredericActivityMuscleGroup.Chest:
        return 'chest';
      case FredericActivityMuscleGroup.Back:
        return 'back';
      case FredericActivityMuscleGroup.Legs:
        return 'legs';
      case FredericActivityMuscleGroup.Core:
        return 'core';
      default:
        return 'none';
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is FredericActivity) return this.activityID == other.activityID;
    return false;
  }

  @override
  String toString() {
    return 'FredericActivity[id: $activityID, name: $name, owner: $owner]';
  }

  @override
  int get hashCode => activityID.hashCode;

  @override
  List<DataColumn> toDataColumn() {
    return <DataColumn>[
      DataColumn(
        label: Text(
          'Icon',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      DataColumn(
        label: Text(
          'Name',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Muscle Groups',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      DataColumn(
        label: Text(
          'Type',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      DataColumn(
        label: Text(
          'Owner',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      DataColumn(
        label: Text(
          'Sets',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      DataColumn(
        label: Text(
          'Reps',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
    ];
  }

  @override
  DataRow toDataRow(void Function(FredericActivity)? onSelectElement,
      [bool selected = false]) {
    String muscleGroupsString = '';
    for (var group in muscleGroups) {
      muscleGroupsString += group.toString().split('.').last + ', ';
    }

    return DataRow(onSelectChanged: (x) => onSelectElement?.call(this), cells: [
      DataCell(Container(
          width: 45,
          child: PictureIcon(
            image,
            mainColor: selected ? theme.positiveColor : theme.mainColor,
            accentColor:
                selected ? theme.positiveColorLight : theme.mainColorLight,
          ))),
      DataCell(Text(name)),
      DataCell(Text(muscleGroupsString)),
      DataCell(Text(type.toString().split('.').last)),
      DataCell(Text(owner)),
      DataCell(Text('$recommendedSets')),
      DataCell(Text('$recommendedReps')),
    ]);
  }
}

enum FredericActivityType { Weighted, Calisthenics, Stretch, None }

enum FredericActivityMuscleGroup { Arms, Chest, Back, Core, Legs, None }
