import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';

class FirestoreWorkoutDataInterface
    implements FredericDataInterface<FredericWorkout> {
  FirestoreWorkoutDataInterface(
      {required this.firestoreInstance, required this.workoutsCollection});

  final FirebaseFirestore firestoreInstance;
  final CollectionReference<Map<String, dynamic>> workoutsCollection;

  @override
  Future<FredericWorkout> create(FredericWorkout object) {
    return createFromMap(object.toMap());
  }

  @override
  Future<FredericWorkout> createFromMap(Map<String, dynamic> data) async {
    DocumentReference<Map<String, dynamic>> newWorkout =
        await workoutsCollection.add(data);
    DocumentSnapshot<Map<String, dynamic>> snapshot = await newWorkout.get();
    if (snapshot.data() == null)
      throw Exception('Creation of Activity has Failed!');
    return FredericWorkout.fromMap(snapshot.id, snapshot.data()!);
  }

  @override
  Future<void> delete(FredericWorkout object) {
    return workoutsCollection.doc(object.id).delete();
  }

  @override
  Future<List<FredericWorkout>> get() async {
    List<FredericWorkout> workouts = <FredericWorkout>[];
    QuerySnapshot<Map<String, dynamic>> global =
        await workoutsCollection.where('owner', isEqualTo: 'global').get();

    QuerySnapshot<Map<String, dynamic>> private = await workoutsCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    for (int i = 0; i < global.docs.length; i++) {
      var doc = global.docs[i];
      if (!doc.exists) continue;
      FredericWorkout workout = FredericWorkout.fromMap(doc.id, doc.data());
      workouts.add(workout);
    }
    for (int i = 0; i < private.docs.length; i++) {
      var doc = private.docs[i];
      if (!doc.exists) continue;
      FredericWorkout workout = FredericWorkout.fromMap(doc.id, doc.data());
      workouts.add(workout);
    }
    return workouts;
  }

  @override
  Future<FredericWorkout> update(FredericWorkout object) async {
    await workoutsCollection.doc(object.id).update(object.toMap());
    return object;
  }
}
