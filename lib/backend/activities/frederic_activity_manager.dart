import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/backend.dart';

///
/// Manages all Activities.
///
class FredericActivityManager
    extends Bloc<FredericActivityEvent, FredericActivityListData> {
  FredericActivityManager()
      : super(FredericActivityListData(
            <String>[], HashMap<String, FredericActivity>()));

  final CollectionReference _activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  HashMap<String, FredericActivity> _activities =
      HashMap<String, FredericActivity>();

  FredericActivity? operator [](String value) {
    return _activities[value];
  }

  Iterable<FredericActivity> get activities => _activities.values;

  void reload() async {
    QuerySnapshot<Object?> global =
        await _activitiesCollection.where('owner', isEqualTo: 'global').get();
    QuerySnapshot<Object?> private = await _activitiesCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    List<String> changed = <String>[];
    _activities.clear();

    for (int i = 0; i < global.docs.length; i++) {
      _activities[global.docs[i].id] = FredericActivity(global.docs[i]);
      changed.add(global.docs[i].id);
    }
    for (int i = 0; i < private.docs.length; i++) {
      _activities[private.docs[i].id] = FredericActivity(private.docs[i]);
      changed.add(private.docs[i].id);
    }

    add(FredericActivityEvent(changed));
  }

  Future<FredericActivity> getActivity(String id) async {
    if (_activities.containsKey(id)) return _activities[id]!;

    DocumentSnapshot<Object?> snapshot =
        await _activitiesCollection.doc(id).get();

    if (snapshot.exists) {
      _activities[id] = FredericActivity(snapshot);
      return _activities[id]!;
    }

    return FredericActivity.empty();
  }

  @override
  Stream<FredericActivityListData> mapEventToState(
      FredericActivityEvent event) async* {
    if (event is FredericActivityUpdateEvent) {
      _activities[event.updated.activityID] = event.updated;
      yield FredericActivityListData([event.updated.activityID], _activities);
    } else if (event is FredericActivityCreateEvent) {
      DocumentReference newActivity = await _activitiesCollection.add({
        'name': event.newActivity.name,
        'description': event.newActivity.description,
        'image': event.newActivity.image,
        'recommendedsets': event.newActivity.recommendedSets,
        'recommendedreps': event.newActivity.recommendedReps,
        'owner': FirebaseAuth.instance.currentUser?.uid,
        'musclegroup': FredericActivity.parseMuscleGroupListToStringList(
            event.newActivity.muscleGroups)
      });
      DocumentSnapshot<Object?> newActivitySnapshot = await newActivity.get();
      _activities[newActivity.id] = FredericActivity(newActivitySnapshot);
      yield FredericActivityListData([newActivity.id], _activities);
    } else if (event is FredericActivityEvent) {
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
  FredericActivityUpdateEvent(this.updated)
      : super(<String>[updated.activityID]);

  FredericActivity updated;
}

class FredericActivityCreateEvent extends FredericActivityEvent {
  FredericActivityCreateEvent(this.newActivity)
      : super(<String>[newActivity.activityID]);

  FredericActivity newActivity;
}
