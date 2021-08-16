import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frederic/backend/data_store/frederic_document_snapshot.dart';

class FredericQuerySnapshot {
  FredericQuerySnapshot(this.docs);

  FredericQuerySnapshot.fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot)
      : docs = <FredericDocumentSnapshot>[] {
    for (var doc in snapshot.docs) {
      docs.add(FredericDocumentSnapshot(doc.id, data: doc.data()));
    }
  }

  final List<FredericDocumentSnapshot> docs;
}
