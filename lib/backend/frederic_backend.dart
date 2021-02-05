import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend.dart';

class FredericBackend {
  FredericBackend(this._firebaseAuth)
      : _authenticationService = AuthenticationService(_firebaseAuth);

  static FredericBackend of(BuildContext context) {
    return context.read<FredericBackend>();
  }

  final FirebaseAuth _firebaseAuth;
  final AuthenticationService _authenticationService;

  FredericUser currentUser;
  Stream<FredericUser> _currentUserStream;
  StreamController<FredericUser> _currentUserStreamController;

  Stream<FredericUser> get currentUserStream => _currentUserStream;
  AuthenticationService get authService => _authenticationService;

  ///
  /// Use this to load the data for the currentUser, instead of using
  /// currentUser.loadData().
  ///
  Future<FredericUser> loadCurrentUser() async {
    await currentUser.loadData();
    _currentUserStreamController = StreamController<FredericUser>();
    _currentUserStream =
        _currentUserStreamController.stream.asBroadcastStream();
    _loadCurrentUserStream();
    return currentUser;
  }

  void _loadCurrentUserStream() {
    if (currentUser?.uid == null) {
      return null;
    }

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    Stream<DocumentSnapshot> userStream =
        usersCollection.doc(currentUser.uid).snapshots();

    userStream.listen((event) {
      currentUser.insertDocumentSnapshot(event);
      _currentUserStreamController.add(currentUser);
    });
  }

  // ===========================================================================
  /// Gets all global activities and the activities of the current user
  ///
  /// Not as versatile as loading activities one by one but much more performant
  ///
  static Future<List<FredericActivity>> getAllActivities(
      [bool loadSets = false]) async {
    CollectionReference activitiesCollection =
        FirebaseFirestore.instance.collection('activities');
    List<FredericActivity> activities = List<FredericActivity>();

    QuerySnapshot snapshot1 = await activitiesCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();

    QuerySnapshot snapshot2 =
        await activitiesCollection.where('owner', isEqualTo: 'global').get();

    for (int i = 0; i < snapshot1.docs.length; i++) {
      var map = snapshot1.docs[i];
      FredericActivity a = FredericActivity(map.id);
      a.insertSnapshot(map);
      if (loadSets) await a.loadSets();
      activities.add(a);
    }
    for (int i = 0; i < snapshot2.docs.length; i++) {
      var map = snapshot2.docs[i];
      FredericActivity a = FredericActivity(map.id);
      a.insertSnapshot(map);
      if (loadSets) await a.loadSets();
      activities.add(a);
    }
    return activities;
  }

  // ===========================================================================
  /// Loads all activities the user has access to in a stream
  /// returns a StreamController because the controller has to be closed on dispose
  ///
  static StreamController<List<FredericActivity>> getAllActivitiesStream() {
    CollectionReference activitiesCollection =
        FirebaseFirestore.instance.collection('activities');
    List<FredericActivity> activities = List<FredericActivity>();
    StreamController<List<FredericActivity>> controller =
        StreamController<List<FredericActivity>>();

    Stream<QuerySnapshot> stream1 = activitiesCollection
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();
    Stream<QuerySnapshot> stream2 =
        activitiesCollection.where('owner', isEqualTo: 'global').snapshots();

    Stream<QuerySnapshot> stream = StreamGroup.merge([stream1, stream2]);

    stream.listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        var map = event.docs[i];
        FredericActivity a = FredericActivity(map.id);
        a.insertSnapshot(map);
        if (activities.contains(a)) {
          activities.remove(a);
        }
        activities.add(a);
      }
      controller.add(activities);
    });

    return controller;
  }
}
