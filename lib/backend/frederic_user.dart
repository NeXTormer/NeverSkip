import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///
/// Represents the user of the app
///
class FredericUser {
  FredericUser(String uid) {
    _uid = uid;
  }

  String _uid;
  String _email;
  String _name;
  String _profileImage;
  String _bannerImage;
  String _currentWorkoutID;
  DateTime _birthday;

  String get uid => _uid;
  String get email => _email;
  String get name => _name;
  String get image => _profileImage;
  String get banner => _bannerImage;
  String get currentWorkoutID => _currentWorkoutID;
  DateTime get birthday => _birthday;

  int get age {
    var diff = _birthday.difference(DateTime.now());
    return diff.inDays ~/ 365;
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

  Future<FredericUser> loadData() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userEntry = await usersCollection.doc(_uid).get();

    if (userEntry.data() == null) {
      //TODO: implement proper sign up process
      return null;
    }

    _email = FirebaseAuth.instance.currentUser.email;
    _name = userEntry.data()['name'];
    _profileImage = userEntry.data()['image'];
    _bannerImage = userEntry.data()['banner'];
    _birthday = userEntry.data()['birthday'].toDate();
    _currentWorkoutID = userEntry.data()['currentworkout'];
    return this;
  }

  @override
  String toString() {
    return 'FredericUser[name: $name, email: $email, birthday: $birthday, currentworkout: $currentWorkoutID, uid: $uid]';
  }
}
