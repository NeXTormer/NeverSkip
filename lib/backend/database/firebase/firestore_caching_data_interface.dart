import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:hive/hive.dart';

class FirestoreCachingDataInterface<T extends FredericDataObject>
    implements FredericDataInterface<T> {
  FirestoreCachingDataInterface({
    required this.name,
    required this.collectionReference,
    required this.queries,
    required this.firestoreInstance,
    required this.generateObject,
  });

  String name;
  CollectionReference<Map<String, dynamic>> collectionReference;
  List<Query<Map<String, dynamic>>> queries;
  FirebaseFirestore firestoreInstance;
  T Function(String id, Map<String, dynamic> data) generateObject;

  Box<T>? _box;

  @override
  Future<T> create(T object) {
    return createFromMap(object.toMap());
  }

  @override
  Future<T> createFromMap(Map<String, dynamic> data) async {
    DocumentReference<Map<String, dynamic>> newActivity =
        await collectionReference.add(data);
    DocumentSnapshot<Map<String, dynamic>> snapshot = await newActivity.get();
    if (snapshot.data() == null)
      throw Exception('Creation of Activity has Failed!');
    return generateObject(snapshot.id, snapshot.data()!);
  }

  @override
  Future<void> delete(T object) {
    return collectionReference.doc(object.id).delete();
  }

  @override
  Future<T> update(T object) async {
    await collectionReference.doc(object.id).update(object.toMap());
    return object;
  }

  @override
  Future<List<T>> get() async {
    if (await Hive.boxExists(name)) {
      if (_box == null) _box = await Hive.openBox(name);
      return _box!.values.toList();
    } else {
      return reload();
    }
  }

  @override
  Future<List<T>> reload() async {
    if (_box == null) {
      _box = await Hive.openBox(name);
    } else {
      await _box!.clear();
    }

    List<T> data = <T>[];
    Map<String, T> entries = <String, T>{};

    for (final query in queries) {
      QuerySnapshot<Map<String, dynamic>?> querySnapshot = await query.get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var doc = querySnapshot.docs[i];
        if (doc.data() == null) continue;
        final object = generateObject(doc.id, doc.data()!);
        data.add(object);
        entries[doc.id] = object;
      }
    }
    _box!.putAll(entries);
    return data;
  }
}
