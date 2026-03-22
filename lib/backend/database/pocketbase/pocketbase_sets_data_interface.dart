import 'package:frederic/backend/database/frederic_data_interface.dart';
import 'package:frederic/backend/sets/frederic_set.dart';
import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseSetsDataInterface implements FredericDataInterface<FredericSetDocument> {
  PocketbaseSetsDataInterface({
    required this.pb,
    required this.userId,
    this.collectionName = 'sets',
    this.name = 'Sets',
  });

  final PocketBase pb;
  final String userId;
  final String collectionName;
  final String name;

  Box<FredericSetDocument>? _box;

  @override
  Future<FredericSetDocument> create(FredericSetDocument object) async {
    // In our individual-record model, adding a "document" usually means adding its sets.
    // However, FredericSetList calls createFromMap for new months.
    return object; 
  }

  @override
  Future<FredericSetDocument> createFromMap(Map<String, dynamic> data) async {
    final activityId = data['activityid'];
    final month = data['month'];
    final List<dynamic> setsData = data['sets'] ?? [];

    List<FredericSet> createdSets = [];
    for (var setData in setsData) {
      final record = await pb.collection(collectionName).create(body: {
        'owner': userId,
        'activityid': activityId,
        'month': month,
        ...setData,
      });
      createdSets.add(FredericSet.fromMap(record.data, id: record.id));
    }

    final doc = FredericSetDocument(activityId + month.toString(), createdSets);
    doc.fromMap(doc.id, {
      'activityid': activityId,
      'month': month,
      'sets': createdSets.map((s) => s.toMap()).toList(),
    });

    if (_box == null) _box = await Hive.openBox(name);
    _box!.put(doc.id, doc);

    return doc;
  }

  @override
  Future<void> delete(FredericSetDocument object) async {
    // Deleting a monthly document means deleting all its records in PB
    // But usually we delete individual sets.
    final records = await pb.collection(collectionName).getFullList(
      filter: 'owner = "$userId" && activityid = "${object.activityID}" && month = ${object.month}',
    );
    for (var r in records) {
      await pb.collection(collectionName).delete(r.id);
    }
    await _box?.delete(object.id);
  }

  @override
  Future<FredericSetDocument> update(FredericSetDocument object) async {
    // Look for sets in the document that have NO id (newly added sets)
    // and create them in PocketBase.
    for (int i = 0; i < object.sets.length; i++) {
      final set = object.sets[i];
      if (set.id.isEmpty) {
        final record = await pb.collection(collectionName).create(body: {
          'owner': userId,
          'activityid': object.activityID,
          'month': object.month,
          ...set.toMap(),
        });
        // Replace the set in the list with one that has the ID
        object.sets[i] = FredericSet.fromMap(record.data, id: record.id);
      } else {
        // Optionally update existing sets if they changed (not supported by UI yet)
      }
    }

    if (_box == null) _box = await Hive.openBox(name);
    _box!.put(object.id, object);
    
    return object;
  }

  @override
  Future<List<FredericSetDocument>> get() async {
    if (await Hive.boxExists(name)) {
      if (_box == null) _box = await Hive.openBox(name);
      return _box!.values.toList();
    }
    return reload();
  }

  @override
  Future<List<FredericSetDocument>> reload() async {
    if (_box == null) {
      _box = await Hive.openBox(name);
    } else {
      await _box!.clear();
    }

    final profiler = FredericProfiler.track('Load and Aggregate PB Sets');
    
    final records = await pb.collection(collectionName).getFullList(
      filter: 'owner = "$userId"',
      sort: 'month,activityid',
    );

    Map<String, List<FredericSet>> grouped = {};
    Map<String, Map<String, dynamic>> docMetas = {};

    for (var record in records) {
      final activityId = record.getStringValue('activityid');
      final month = record.getIntValue('month');
      final docId = activityId + month.toString();

      grouped.putIfAbsent(docId, () => []);
      grouped[docId]!.add(FredericSet.fromMap(record.data, id: record.id));
      
      docMetas[docId] = {
        'activityid': activityId,
        'month': month,
      };
    }

    List<FredericSetDocument> docs = [];
    for (var docId in grouped.keys) {
      final doc = FredericSetDocument(docId, grouped[docId]!);
      // We need to trigger its internal population if necessary, but
      // we already passed the sets list in constructor.
      // However, to satisfy internal state:
      doc.fromMap(docId, {
        'activityid': docMetas[docId]!['activityid'],
        'month': docMetas[docId]!['month'],
        'sets': [] // sets are already in the object
      });
      doc.sets = grouped[docId]!; 
      
      docs.add(doc);
      _box!.put(docId, doc);
    }

    profiler.stop();
    return docs;
  }

  @override
  Future<void> deleteFromDisk() {
    return Hive.deleteBoxFromDisk(name);
  }
}
