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
      this.statusMessage = ''}) {
    insertDocumentSnapshot(snapshot);
  }

  final String _uid;
  final String statusMessage;
  late final String _email;
  late final String _name;
  late final String _image;
  late final int? _weight;
  late final int? _height;
  late final DateTime? _birthday;
  late final List<String> _activeWorkouts;
  late final List<String> _progressMonitors;

  bool get authenticated => _uid != '';
  String get uid => _uid;
  String get email => _email;
  String get name => _name;
  String get image => _image;
  int get weight => _weight ?? -1;
  int get height => _height ?? -1;
  DateTime get birthday => _birthday ?? DateTime.now();
  List<String> get progressMonitors => _progressMonitors ?? [];
  List<String> get activeWorkouts => _activeWorkouts ?? [];

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
    return 'FredericUser[name: $name, email: $email, uid: $uid]';
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
