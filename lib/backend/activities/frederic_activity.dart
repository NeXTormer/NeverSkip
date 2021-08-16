import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/data_table.dart';
import 'package:frederic/admin_panel/data_table_element.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/state/activity_filter_controller.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

///
/// Represents a single Activity.
/// Changes made using the classes properties are automatically updated in the
/// database and on all listeners of the ActivityManagerBloc
///
class FredericActivity implements DataTableElement<FredericActivity> {
  ///
  /// Construct FredericActivity using a DocumentSnapshot from the database
  ///
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
    _type = parseType(data['type']);

    List<dynamic> muscleGroups = data['musclegroup'];
    muscleGroups.forEach((element) {
      if (element is String) _muscleGroups.add(parseSingleMuscleGroup(element));
    });
  }

  ///
  /// Constructs an empty Activity with an empty activity ID
  ///
  FredericActivity.empty() : activityID = '';

  ///
  /// Returns an existing Activity using the provided ID. If the activity
  /// does not exist, an empty Activity is returned
  ///
  factory FredericActivity.fromID(String id) {
    return FredericBackend.instance.activityManager[id] ??
        FredericActivity.empty();
  }

  ///
  /// Creates a new activity (only locally)
  /// Use this activity to push a FredericActivityCreateEvent to the
  /// ActivityManager
  ///
  FredericActivity.create(
      {required String name,
      required String description,
      required String image,
      required int recommendedreps,
      required int recommendedsets,
      required List<FredericActivityMuscleGroup> muscleGroups,
      required FredericActivityType type})
      : activityID = 'new-activity',
        _name = name,
        _description = description,
        _image = image,
        _recommendedReps = recommendedreps,
        _recommendedSets = recommendedsets,
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

  String get name => _name ?? 'Empty activity';
  String get description => _description ?? '';
  String get image =>
      _image ?? 'https://via.placeholder.com/400x400?text=noimage';
  String get owner => _owner ?? 'No owner';
  int get recommendedReps => _recommendedReps ?? 1;
  int get recommendedSets => _recommendedSets ?? 1;
  bool get isNotLoaded => _name == null;

  bool get isGlobalActivity {
    return _owner == 'global';
  }

  String get progressUnit {
    if (_type == FredericActivityType.Weighted) return 'kg';
    if (_type == FredericActivityType.Calisthenics) return 'reps';
    if (_type == FredericActivityType.Stretch) return 's';
    return '';
  }

  List<FredericActivityMuscleGroup> get muscleGroups => _muscleGroups;
  FredericActivityType get type => _type;

  ///
  /// Also updates the name on the Database
  ///
  set name(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'name': value});
      _name = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  ///
  /// Also updates the description on the Database
  ///
  set description(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'description': value});
      _description = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  ///
  /// Also updates the image on the Database
  ///
  set image(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'image': value});
      _image = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  ///
  /// Also updates the recommended reps on the Database
  ///
  set recommendedReps(int value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'recommendedreps': value});
      _recommendedReps = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  ///
  /// Also updates the recommended sets on the Database
  ///
  set recommendedSets(int value) {
    if (value >= 0) {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityID)
          .update({'recommendedsets': value});
      _recommendedSets = value;
      FredericBackend.instance.activityManager
          .add(FredericActivityUpdateEvent(this));
    }
  }

  //============================================================================
  /// returns true if the activity matches the provided Filter Controller
  ///
  bool matchFilterController(ActivityFilterController controller) {
    bool match = false;
    if (!controller.types[_type]!) return false;
    for (var value in controller.muscleGroups.entries) {
      if (value.value) {
        if (_muscleGroups.contains(value.key)) match = true;
      }
    }
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

  //============================================================================
  /// Parses the type String from the DB to the [FredericActivityType] object.
  /// The String can be:
  ///   - weighted
  ///   - cali
  ///   - stretch
  ///
  static FredericActivityType parseType(String? typeString) {
    if (typeString == 'weighted') return FredericActivityType.Weighted;
    if (typeString == null) return FredericActivityType.Weighted;
    if (typeString == 'cali') return FredericActivityType.Calisthenics;
    if (typeString == 'stretch') return FredericActivityType.Stretch;
    return FredericActivityType.Weighted;
  }

  //============================================================================
  /// Parses a muscle groups list from the DB to the [List<FredericActivityMuscleGroup>] object.
  /// The String can be:
  ///   - arms
  ///   - chest
  ///   - back
  ///   - legs
  ///   - abs
  ///   - '' or none
  ///
  static List<FredericActivityMuscleGroup> parseMuscleGroups(
      List<String> muscleGroupsStrings) {
    List<FredericActivityMuscleGroup> l = <FredericActivityMuscleGroup>[];
    for (int i = 0; i < muscleGroupsStrings.length; i++) {
      l.add(parseSingleMuscleGroup(muscleGroupsStrings[i]));
    }
    return l;
  }

  //============================================================================
  /// Parses the muscle groups from the DB to the [FredericActivityMuscleGroup] object.
  /// The String can be:
  ///   - arms
  ///   - chest
  ///   - back
  ///   - legs
  ///   - abs
  ///   - '' or none
  ///
  static FredericActivityMuscleGroup parseSingleMuscleGroup(
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

  //============================================================================
  /// Parses the [FredericActivityMuscleGroup] back to a string for the DB
  ///
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

  //============================================================================
  /// Parses a [List<FredericActivityMuscleGroup>] back to a [List<String>] for
  /// the DB
  ///
  static List<String> parseMuscleGroupListToStringList(
      List<FredericActivityMuscleGroup> groupList) {
    List<String> strings = <String>[];
    for (int i = 0; i < groupList.length; i++) {
      strings.add(parseSingleMuscleGroupToString(groupList[i]));
    }
    return strings;
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
  DataRow toDataRow(void Function(FredericActivity)? onSelectElement) {
    String muscleGroupsString = '';
    for (var group in muscleGroups) {
      muscleGroupsString += group.toString().split('.').last + ', ';
    }

    return DataRow(onSelectChanged: (x) => onSelectElement?.call(this), cells: [
      DataCell(Container(width: 45, child: PictureIcon(image))),
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
