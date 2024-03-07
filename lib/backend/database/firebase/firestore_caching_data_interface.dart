import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:hive/hive.dart';

class FirestoreCachingDataInterface<T extends FredericDataObject>
    implements FredericDataInterface<T> {
  FirestoreCachingDataInterface({
    required this.name,
    required this.collectionReference,
    this.queries,
    required this.firestoreInstance,
    required this.generateObject,
  });

  String name;
  CollectionReference<Map<String, dynamic>> collectionReference;
  List<Query<Map<String, dynamic>>>? queries;
  FirebaseFirestore firestoreInstance;
  T Function(String id, Map<String, dynamic> data) generateObject;

  Box<T>? _box;
  bool _reloadedBecauseOfPossibleDataCorruption = false;

  @override
  Future<T> create(T object) {
    return createFromMap(object.toMap());
  }

  @override
  Future<T> createFromMap(Map<String, dynamic> data) async {
    DocumentReference<Map<String, dynamic>> newObjectReference =
        await collectionReference.add(data);
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await newObjectReference.get();
    if (snapshot.data() == null)
      throw Exception('Creation of Activity has Failed!');
    T newObject = generateObject(snapshot.id, snapshot.data()!);
    _box!.put(newObject.id, newObject);
    return newObject;
  }

  @override
  Future<void> delete(T object) async {
    await _box!.delete(object.id);
    await collectionReference.doc(object.id).delete();
  }

  @override
  Future<T> update(T object) async {
    await collectionReference.doc(object.id).update(object.toMap());
    await _box!.put(object.id, object);
    return object;
  }

  @override
  Future<List<T>> get() async {
    if (await Hive.boxExists(name)) {
      final profiler =
          await FredericProfiler.trackFirebase('Load cached $name from Box');
      if (_box == null) _box = await Hive.openBox(name);
      if (_box!.isEmpty) {
        // If the stored box is empty it is possible that the box was corrupted
        // (for example when the app was open for a day on the emulator)
        // Try to reload once from the DB in case there was corrupted data
        if (!_reloadedBecauseOfPossibleDataCorruption) {
          _reloadedBecauseOfPossibleDataCorruption = true;
          return reload();
        }
      }
      profiler?.stop();
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

    if (queries == null) {
      queries = [collectionReference.limit(10000)];
    }
    for (final query in queries!) {
      QuerySnapshot<Map<String, dynamic>?> querySnapshot = await query.get();
      final profiler = FredericProfiler.track('Parse $name Query');
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var doc = querySnapshot.docs[i];
        if (doc.data() == null) continue;
        final object = generateObject(doc.id, doc.data()!);
        data.add(object);
        entries[doc.id] = object;
      }
      profiler.stop();
    }

    _box!.putAll(entries);
    return data;
  }

  @override
  Future<void> deleteFromDisk() {
    return Hive.deleteBoxFromDisk(name);
  }
}
