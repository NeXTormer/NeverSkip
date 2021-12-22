import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:hive/hive.dart';

class FirestoreActivityDataInterface
    implements FredericDataInterface<FredericActivity> {
  FirestoreActivityDataInterface(
      {required this.firestoreInstance, required this.activitiesCollection});

  final FirebaseFirestore firestoreInstance;
  final CollectionReference<Map<String, dynamic>> activitiesCollection;

  Box<FredericActivity>? _dataBox;

  @override
  Future<List<FredericActivity>> reload() async {
    if (_dataBox == null) _dataBox = await Hive.openBox('activities');
    await _dataBox!.clear();

    List<FredericActivity> activities = <FredericActivity>[];
    Map<String, FredericActivity> entries = <String, FredericActivity>{};

    QuerySnapshot<Map<String, dynamic>?> global =
        await activitiesCollection.where('owner', isEqualTo: 'global').get();
    QuerySnapshot<Map<String, dynamic>?> private = await activitiesCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    for (int i = 0; i < global.docs.length; i++) {
      var doc = global.docs[i];
      if (doc.data() == null) continue;
      FredericActivity activity = FredericActivity();
      activity.fromMap(doc.id, doc.data()!);
      activities.add(activity);
      entries[doc.id] = activity;
    }

    for (int i = 0; i < private.docs.length; i++) {
      var doc = private.docs[i];
      if (doc.data() == null) continue;
      FredericActivity activity = FredericActivity();
      activity.fromMap(doc.id, doc.data()!);
      activities.add(activity);
      entries[doc.id] = activity;
    }
    _dataBox!.putAll(entries);

    return activities;
  }

  @override
  Future<List<FredericActivity>> get() async {
    if (await Hive.boxExists('activities')) {
      if (_dataBox == null) _dataBox = await Hive.openBox('activities');
      return _dataBox!.values.toList();
    } else {
      return reload();
    }
  }

  @override
  Future<FredericActivity> create(FredericActivity object) {
    return createFromMap(object.toMap());
  }

  @override
  Future<FredericActivity> createFromMap(Map<String, dynamic> data) async {
    DocumentReference<Map<String, dynamic>> newActivity =
        await activitiesCollection.add(data);
    DocumentSnapshot<Map<String, dynamic>> snapshot = await newActivity.get();
    if (snapshot.data() == null)
      throw Exception('Creation of Activity has Failed!');
    return FredericActivity.fromMap(snapshot.id, snapshot.data()!);
  }

  @override
  Future<void> delete(FredericActivity object) {
    return activitiesCollection.doc(object.id).delete();
  }

  @override
  Future<FredericActivity> update(FredericActivity object) async {
    await activitiesCollection.doc(object.id).update(object.toMap());
    return object;
  }
}
