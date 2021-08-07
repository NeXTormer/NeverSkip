import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/goals/frederic_goal_list_data.dart';
import 'frederic_goal.dart';

/// Manages all Goals using the Bloc Pattern
/// Access goals either with bloc builder or with
/// ```
/// FredericBackend.instance.goalManager.state
/// ```
///
class FredericGoalManager
    extends Bloc<FredericGoalEvent, FredericGoalListData> {
  FredericGoalManager()
      : super(
            FredericGoalListData(<String>[], HashMap<String, FredericGoal>()));

  final CollectionReference _goalsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('goals');

  HashMap<String, FredericGoal> _goals = HashMap<String, FredericGoal>();

  FredericGoal? operator [](String value) {
    return _goals[value];
  }

  Iterable<FredericGoal> get goals => _goals.values;

  ///
  /// (Re)Loads all goals from the database
  ///
  void reload() async {
    QuerySnapshot<Object?> private = await _goalsCollection.get();

    List<String> changed = <String>[];
    _goals.clear();

    for (int i = 0; i < private.docs.length; i++) {
      _goals[private.docs[i].id] = FredericGoal(private.docs[i]);
      changed.add(private.docs[i].id);
    }

    add(FredericGoalEvent(changed));
  }

  @override
  Stream<FredericGoalListData> mapEventToState(FredericGoalEvent event) async* {
    if (event is FredericGoalUpdateEvent) {
      _goals[event.updated.activityID] = event.updated;
      yield FredericGoalListData([event.updated.activityID], _goals);
    } else if (event is FredericGoalCreateEvent) {
      DocumentReference newGoal = await _goalsCollection.add({
        'title': event.newGoal.title,
        // TODO Create new Goal
      });
      DocumentSnapshot<Object?> newGoalSnapshot = await newGoal.get();
      _goals[newGoal.id] = FredericGoal(newGoalSnapshot);
      yield FredericGoalListData([newGoal.id], _goals);
    } else if (event is FredericGoalEvent) {
      yield FredericGoalListData(event.changed, _goals);
    }
  }

  @override
  void onTransition(
      Transition<FredericGoalEvent, FredericGoalListData> transition) {
    super.onTransition(transition);
  }
}

class FredericGoalEvent {
  FredericGoalEvent(this.changed);
  List<String> changed;
}

class FredericGoalUpdateEvent extends FredericGoalEvent {
  FredericGoalUpdateEvent(this.updated) : super(<String>[updated.goalID]);

  FredericGoal updated;
}

class FredericGoalCreateEvent extends FredericGoalEvent {
  FredericGoalCreateEvent(this.newGoal) : super(<String>[newGoal.activityID]);

  FredericGoal newGoal;
}
