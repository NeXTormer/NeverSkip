import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

///
/// Represents the user of the app
///
/// Getting other users not yet supported but planned
///
class FredericUser with ChangeNotifier {
  FredericUser(String uid) {
    _uid = uid;
  }

  String _uid;
  String _email;
  String _name;
  String _description;
  String _profileImage;
  String _bannerImage;
  String _currentWorkoutID;
  DateTime _birthday;
  List<String> _progressMonitors;
  List<String> _activeWorkouts;

  String get uid => _uid;
  String get email => _email ?? 'nouser@hawkford.io';
  String get name => _name ?? 'noname';
  String get description => _description ?? '';
  String get image =>
      _profileImage ?? 'https://via.placeholder.com/300x300?text=profile';
  String get banner =>
      _bannerImage ?? 'https://via.placeholder.com/1000x400?text=nobannerimage';
  String get currentWorkoutID => _currentWorkoutID ?? '';
  DateTime get birthday => _birthday ?? DateTime.now();
  List<String> get progressMonitors => _progressMonitors ?? [];
  List<String> get activeWorkouts => _activeWorkouts ?? [];

  int get age {
    var diff = birthday.difference(DateTime.now());
    return diff.inDays ~/ 365;
  }

  set uid(String value) {
    if (value.isNotEmpty) _uid = value;
  }

  ///
  /// Also updates the name in the database
  ///
  set name(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'name': value});
    }
  }

  ///
  /// Also updates the image in the database
  ///
  set image(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'image': value});
    }
  }

  ///
  /// Also updates the banner in the database
  ///
  set banner(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'banner': value});
    }
  }

  ///
  /// Also updates the currentworkout in the database
  ///
  set currentWorkoutID(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'currentworkout': value});
    }
  }

  ///
  /// Also updates the description in the database
  ///
  set description(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'description': value});
    }
  }

  void insertDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) {
      return null;
    }

    _email = FirebaseAuth.instance.currentUser.email;
    _name = snapshot.data()['name'];
    _description = snapshot.data()['description'];
    _profileImage = snapshot.data()['image'];
    _bannerImage = snapshot.data()['banner'];
    _birthday = snapshot.data()['birthday']?.toDate();
    _currentWorkoutID = snapshot.data()['currentworkout'];
    _progressMonitors = snapshot.data()['progressmonitors']?.cast<String>();
    _activeWorkouts = snapshot.data()['activeworkouts']?.cast<String>();
    notifyListeners();
  }

  static Future<void> createUserEntryInDB(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': 'Jane Doe',
      'banner':
          'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/defaultimages%2Fdefault-banner.jpg?alt=media&token=5441a2a6-14e8-448e-b010-d359adfac6b5',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/defaultimages%2Fdefault-profile-screen.jpg?alt=media&token=52f200e9-fac8-4295-bf7d-01b59f92a987',
      'description': ''
    });
    return;
  }

  @override
  String toString() {
    return 'FredericUser[name: $name, email: $email, birthday: $birthday, currentworkout: $currentWorkoutID, uid: $uid]';
  }
}
