import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

class FredericUser {
  String _uid;
  String _email;
  String _username;
  String _profileImage;
  String _bannerImage;
  DateTime _birthday;

  String get uid => _uid;
  String get email => _email;
  String get username => _username;
  String get profileImage => _profileImage;
  String get bannerImage => _bannerImage;
  DateTime get birthday => _birthday;

  int get age {
    var diff = _birthday.difference(DateTime.now());
    return diff.inDays ~/ 365;
  }

  FredericUser(User user) {
    _uid = user.uid;
    readData();
  }

  Future<FredericUser> readData() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userEntry = await usersCollection.doc(_uid).get();
    _username = userEntry.data()['name'];
    _email = userEntry.data()['email'];
    _profileImage = userEntry.data()['profileimage'];
    _bannerImage = userEntry.data()['bannerimage'];
    _birthday = userEntry.data()['birthday'].toDate();
    return this;
  }
}
