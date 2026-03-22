import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseCachingDataInterface<T extends FredericDataObject> implements FredericDataInterface<T> {
  PocketbaseCachingDataInterface({
    required this.name,
    required this.collectionName,
    required this.pb,
    required this.generateObject,
    this.filter = '',
    this.sort = '',
  });

  String name;
  String collectionName;
  PocketBase pb;
  String filter;
  String sort;
  
  T Function(String id, Map<String, dynamic> data) generateObject;

  Box<T>? _box;
  bool _reloadedBecauseOfPossibleDataCorruption = false;

  @override
  Future<T> create(T object) {
    return createFromMap(object.toMap());
  }

  @override
  Future<T> createFromMap(Map<String, dynamic> data) async {
    final record = await pb.collection(collectionName).create(body: data);
    T newObject = generateObject(record.id, record.data);
    _box!.put(newObject.id, newObject);
    return newObject;
  }

  @override
  Future<void> delete(T object) async {
    await _box!.delete(object.id);
    await pb.collection(collectionName).delete(object.id);
  }

  @override
  Future<T> update(T object) async {
    final record = await pb.collection(collectionName).update(object.id, body: object.toMap());
    T updatedObject = generateObject(record.id, record.data);
    await _box!.put(updatedObject.id, updatedObject);
    return updatedObject;
  }

  @override
  Future<List<T>> get() async {
    if (await Hive.boxExists(name)) {
      final profiler = await FredericProfiler.track('Load cached $name from Box');
      if (_box == null) _box = await Hive.openBox(name);
      if (_box!.isEmpty) {
        if (!_reloadedBecauseOfPossibleDataCorruption) {
          _reloadedBecauseOfPossibleDataCorruption = true;
          return reload();
        }
      }
      profiler.stop();
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

    final profiler = FredericProfiler.track('Parse PB $name Query');
    
    // Auto-paginate through all records
    final records = await pb.collection(collectionName).getFullList(
      filter: filter.isNotEmpty ? filter : null,
      sort: sort.isNotEmpty ? sort : null,
    );

    for (var record in records) {
      final object = generateObject(record.id, record.data);
      data.add(object);
      entries[record.id] = object;
    }
    profiler.stop();

    _box!.putAll(entries);
    return data;
  }

  @override
  Future<void> deleteFromDisk() {
    return Hive.deleteBoxFromDisk(name);
  }
}
