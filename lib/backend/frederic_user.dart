import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///
/// Represents the user of the app
///
/// Getting other users not yet supported but planned
///
class FredericUser {
  FredericUser(this._uid,
      {DocumentSnapshot<Map<String, dynamic>>? snapshot,
      this.statusMessage = '',
      this.waiting = false}) {
    insertDocumentSnapshot(snapshot);
  }

  final String _uid;
  final String statusMessage;
  String? _email;
  String? _name;
  String? _image;
  int? _weight;
  int? _height;
  bool waiting;
  DateTime? _birthday;
  List<String>? _activeWorkouts;
  List<String>? _progressMonitors;

  bool get authenticated => _uid != '';
  bool get finishedLoading => _name != null;
  String get uid => _uid;
  String get email => _email ?? '';
  String get name => _name ?? '';
  String get image =>
      _image ?? 'https://via.placeholder.com/300x300?text=profile';
  int get weight => _weight ?? -1;
  int get height => _height ?? -1;
  DateTime get birthday => _birthday ?? DateTime.now();
  List<String> get progressMonitors => _progressMonitors ?? const <String>[];
  List<String> get activeWorkouts => _activeWorkouts ?? const <String>[];

  int get age {
    var diff = birthday.difference(DateTime.now());
    return diff.inDays ~/ 365;
  }

  void insertDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>>? snapshot) {
    if (snapshot?.data() == null) return;

    _email = FirebaseAuth.instance.currentUser?.email ?? '';
    _name = snapshot!.data()?['name'] ?? '';
    _image = snapshot!.data()?['image'] ??
        'https://via.placeholder.com/300x300?text=profile';
    _weight = snapshot!.data()?['weight'];
    _height = snapshot!.data()?['height'];
    _birthday = snapshot!.data()?['birthday']?.toDate();
    _progressMonitors = snapshot!.data()?['progressmonitors']?.cast<String>() ??
        const <String>[];
    _activeWorkouts =
        snapshot!.data()?['activeworkouts']?.cast<String>() ?? const <String>[];
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other);
  }

  @override
  String toString() {
    return 'FredericUser[$uid, $name, waiting: $waiting, authenticated: $authenticated]';
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
