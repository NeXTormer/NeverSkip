import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FredericUser {
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
  String get profileImage => _profileImage;
  String get bannerImage => _bannerImage;
  String get currentWorkoutID => _currentWorkoutID;
  DateTime get birthday => _birthday;

  int get age {
    var diff = _birthday.difference(DateTime.now());
    return diff.inDays ~/ 365;
  }

  set name(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({'name': value});
    }
  }

  set profileImage(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({'profileimage': value});
    }
  }

  set bannerImage(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({'bannerimage': value});
    }
  }

  set currentWorkoutID(String value) {
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({'currentworkout': value});
    }
  }

  FredericUser(User user) {
    _uid = user.uid;
  }

  Future<FredericUser> loadData() async {
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userEntry = await usersCollection.doc(_uid).get();

    if (userEntry.data() == null) {
      //TODO: implement proper sign up process
      return null;
    }

    _name = userEntry.data()['name'];
    _email = userEntry.data()['email'];
    _profileImage = userEntry.data()['profileimage'];
    _bannerImage = userEntry.data()['bannerimage'];
    _birthday = userEntry.data()['birthday'].toDate();
    _currentWorkoutID = userEntry.data()['currentworkout'];
    return this;
  }

  @override
  String toString() {
    return 'FredericUser[name: $name, email: $email, birthday: $birthday, currentworkout: $currentWorkoutID, uid: $uid]';
  }
}
