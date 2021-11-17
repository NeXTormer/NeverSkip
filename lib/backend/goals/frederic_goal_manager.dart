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

  HashMap<String, FredericGoal> _goals = HashMap<String, FredericGoal>();

  CollectionReference<Map<String, dynamic>> get _goalsCollection =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('goals');

  set goals(List<String> value) {
    if (FirebaseAuth.instance.currentUser?.uid == '') return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'goals': value});
  }

  FredericGoal? operator [](String value) {
    return _goals[value];
  }

  ///
  /// (Re)Loads all goals from the database
  ///
  Future<void> reload() async {
    QuerySnapshot<Object?> private = await _goalsCollection.get();

    List<String> changed = <String>[];
    _goals.clear();

    for (int i = 0; i < private.docs.length; i++) {
      _goals[private.docs[i].id] = FredericGoal(private.docs[i], this);
      changed.add(private.docs[i].id);
    }

    add(FredericGoalEvent(changed));
  }

  @override
  Stream<FredericGoalListData> mapEventToState(FredericGoalEvent event) async* {
    if (event is FredericGoalUpdateEvent) {
      yield FredericGoalListData(event.changed, _goals);
    } else if (event is FredericGoalCreateEvent) {
      _goals[event.newGoal.goalID] = event.newGoal;
      yield FredericGoalListData(event.changed, _goals);
    } else if (event is FredericGoalDeleteEvent) {
      _goalsCollection.doc(event.goal.goalID).delete();
      _goals.remove(event.goal.goalID);
      yield FredericGoalListData(event.changed, _goals);
    } else if (event is FredericGoalEvent) {
      yield FredericGoalListData(event.changed, _goals);
    }
  }

  @override
  void onTransition(
      Transition<FredericGoalEvent, FredericGoalListData> transition) {
    // print('============');
    // print(transition);
    // print('============');
    super.onTransition(transition);
  }
}

class FredericGoalEvent {
  FredericGoalEvent(this.changed);
  List<String> changed;
}

class FredericGoalUpdateEvent extends FredericGoalEvent {
  FredericGoalUpdateEvent(String updated) : super([updated]);
}

class FredericGoalCreateEvent extends FredericGoalEvent {
  FredericGoalCreateEvent(this.newGoal) : super([newGoal.goalID]);
  FredericGoal newGoal;
}

class FredericGoalDeleteEvent extends FredericGoalEvent {
  FredericGoalDeleteEvent(this.goal) : super([goal.goalID]);
  FredericGoal goal;
}
