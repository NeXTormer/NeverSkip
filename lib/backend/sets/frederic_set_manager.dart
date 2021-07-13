import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';

class FredericSetManager extends Bloc<FredericSetEvent, FredericSetListData> {
  FredericSetManager()
      : super(FredericSetListData(
            <String>[], HashMap<String, FredericSetList>())) {
    setsCollection = FirebaseFirestore.instance
        .collection('users/${FirebaseAuth.instance.currentUser?.uid}/sets');
  }

  late final CollectionReference<Map<String, dynamic>> setsCollection;
  final int currentMonth = FredericSetDocument.calculateMonth(DateTime.now());
  static final int startingYear = 2021;

  HashMap<String, FredericSetList> _sets = HashMap<String, FredericSetList>();

  FredericSetList operator [](String value) {
    if (!_sets.containsKey(value))
      _sets[value] = FredericSetList(value, this)..loadData(2);
    return _sets[value]!;
  }

  void _loadOrAddNewSet(String id) {
    if (!_sets.containsKey(id)) {
      _sets[id] = FredericSetList(id, this)..loadData(2);
    }
    add(FredericSetEvent(<String>[id]));
  }

  @override
  void onTransition(
      Transition<FredericSetEvent, FredericSetListData> transition) {
    // print('============');
    // print(transition);
    // print('============');
    super.onTransition(transition);
  }

  @override
  Stream<FredericSetListData> mapEventToState(FredericSetEvent event) async* {
    yield FredericSetListData(event.changedActivities, _sets);
  }
}

class FredericSetListData {
  FredericSetListData(this.changedActivities, this.sets);
  final List<String> changedActivities;
  final HashMap<String, FredericSetList> sets;

  FredericSetList operator [](String value) {
    if (!sets.containsKey(value)) {
      FredericBackend.instance.setManager._loadOrAddNewSet(value);
      //TODO: find a better solution
      return FredericSetList(value, FredericBackend.instance.setManager);
    }
    return sets[value]!;
  }

  bool operator ==(other) => false;

  bool hasChanged(String activityID) => changedActivities.contains(activityID);

  @override
  int get hashCode => changedActivities.hashCode + sets.hashCode;
}

class FredericSetEvent {
  FredericSetEvent(this.changedActivities);
  final List<String> changedActivities;
}
