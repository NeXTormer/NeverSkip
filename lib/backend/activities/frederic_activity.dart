import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/admin_panel/data_table_element.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:frederic/main.dart';
import 'package:frederic/state/activity_filter_controller.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class FredericActivity
    implements DataTableElement<FredericActivity>, FredericDataObject {
  FredericActivity();

  FredericActivity.fromMap(String id, Map<String, dynamic> data) {
    fromMap(id, data);
  }

  ///
  /// Constructs an empty Activity, used for creating a new Activity
  ///
  FredericActivity.create(String ownerID)
      : id = '',
        _name = tr('misc.new_activity'),
        _description = '',
        _owner = ownerID,
        _image =
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fdumbbell.png?alt=media&token=89899620-f4b0-4624-bd07-e06c76c113fe';

  ///
  /// Constructs an Activity Template, used for creating a new Activity
  ///
  /// _only use in admin panel_
  ///
  FredericActivity.globalTemplate()
      : id = '',
        _image =
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Floading.png?alt=media&token=4f99ab1f-c0bb-4881-b010-4c395b3206a1';

  FredericActivity.noSuchActivity(String id)
      : this.id = id,
        _name = tr('misc.activity_not_found'),
        _description = tr('misc.activity_not_found_description'),
        _owner = 'global',
        _image =
            'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Fquestion-mark.png?alt=media&token=b9b9a58c-1a9c-4b2c-8ae0-a8e7245baa9a';

  ///
  /// Creates a new activity (only locally)
  /// Use this activity to push a FredericActivityCreateEvent to the
  /// ActivityManager
  ///
  FredericActivity.make(
      {required String name,
      required String owner,
      required String description,
      required String image,
      required int recommendedReps,
      required int recommendedSets,
      required List<FredericActivityMuscleGroup> muscleGroups,
      required FredericActivityType type})
      : id = '',
        _name = name,
        _description = description,
        _image = image,
        _recommendedReps = recommendedReps,
        _recommendedSets = recommendedSets,
        _muscleGroups = muscleGroups,
        _type = type,
        _owner = owner;

  late final String id;

  @deprecated
  String get activityID => id;

  String? _name;
  String? _nameDE;
  String? _description;
  String? _descriptionDE;
  String? _image;
  String? _owner;
  int? _recommendedSets;
  int? _recommendedReps;

  FredericActivityType _type = FredericActivityType.None;

  List<FredericActivityMuscleGroup> _muscleGroups =
      <FredericActivityMuscleGroup>[];

  String get name => _name ?? '';
  String get description => _description ?? '';
  String get image =>
      _image ??
      'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/icons%2Floading.png?alt=media&token=4f99ab1f-c0bb-4881-b010-4c395b3206a1';
  String get owner => _owner ?? 'No owner';
  int get recommendedReps => _recommendedReps ?? 1;
  int get recommendedSets => _recommendedSets ?? 1;
  bool get isNotLoaded => _name == null;
  bool get isEmpty => id == '';

  /// A proper activity is stored in the DB and has a valid [id]
  bool get isProper => id.length > 16;

  bool get isGlobalActivity => _owner == 'global';
  bool get canEdit => !isGlobalActivity;

  List<FredericActivityMuscleGroup> get muscleGroups => _muscleGroups;
  FredericActivityType get type => _type;

  String get progressUnit {
    if (_type == FredericActivityType.Weighted) return 'kg';
    if (_type == FredericActivityType.Calisthenics)
      return tr('progress.reps.other');
    if (_type == FredericActivityType.Stretch) return 's';
    return '';
  }

  String getNameLocalized([String language = 'en']) {
    if (canEdit) return name;
    if (language == 'de') return _nameDE ?? _name ?? '';
    return _name ?? '';
  }

  String getDescriptionLocalized([String language = 'en']) {
    if (canEdit) return description;
    if (language == 'de') return _descriptionDE ?? _description ?? '';
    return _description ?? '';
  }

  @override
  void fromMap(String id, Map<String, dynamic> data) {
    this.id = id;
    _name = data['name'];
    _nameDE = data['name_de'];
    _description = data['description'];
    _descriptionDE = data['description_de'];
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

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': _name ?? '',
      'name_de': _nameDE,
      'description': _description ?? '',
      'description_de': _descriptionDE,
      'image': image,
      'owner': owner,
      'recommendedreps': recommendedReps,
      'recommendedsets': recommendedSets,
      'type': parseTypeToString(type),
      'musclegroup': parseMuscleGroupListToStringList(muscleGroups)
    };
  }

  void updateData(
      {String? newName,
      String? newDescription,
      String? newImage,
      FredericActivityType? newType,
      List<FredericActivityMuscleGroup>? newMuscleGroups,
      int? newRecommendedReps,
      int? newRecommendedSets}) {
    _name = newName ?? name;
    _description = newDescription ?? description;
    _image = newImage ?? image;
    _type = newType ?? type;
    _muscleGroups = newMuscleGroups ?? muscleGroups;
    _recommendedReps = newRecommendedReps ?? recommendedReps;
    _recommendedSets = newRecommendedSets ?? recommendedSets;
  }

  bool matchFilterController(ActivityFilterController controller) {
    bool match = false;

    if (!controller.types[_type]!) return false;
    for (var value in controller.muscleGroups.entries) {
      if (value.value) {
        if (_muscleGroups.contains(value.key)) match = true;
      }
    }

    //TODO: optimize
    if (controller.muscleGroups.values.every((element) => element == false)) {
      match = true;
    }
    if (controller.muscleGroups.values.every((element) => element == true)) {
      match = true;
    }
    if (controller.muscleGroups.entries.isEmpty) {
      match = true;
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
    if (other is FredericActivity) return this.id == other.id;
    return false;
  }

  @override
  String toString() {
    return 'FredericActivity[id: $id, name: $name, owner: $owner]';
  }

  @override
  int get hashCode => id.hashCode;

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
