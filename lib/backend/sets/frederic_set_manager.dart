import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_list.dart';

class FredericSetManager extends Bloc<FredericSetEvent, FredericSetListData> {
  FredericSetManager() : super(FredericSetListData(<String>[])) {
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

  @override
  Stream<FredericSetListData> mapEventToState(FredericSetEvent event) async* {
    yield FredericSetListData(event.changedActivities);
  }
}

class FredericSetListData {
  FredericSetListData(this.changedActivities);
  final List<String> changedActivities;

  bool isUpdated(String activityID) => changedActivities.contains(activityID);
}

class FredericSetEvent {
  FredericSetEvent(this.changedActivities);
  final List<String> changedActivities;
}
