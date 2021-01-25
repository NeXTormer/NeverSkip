import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'backend.dart';

class FredericBackend {
  FredericBackend(this._firebaseAuth) : _authenticationService = AuthenticationService(_firebaseAuth);

  final FirebaseAuth _firebaseAuth;
  final AuthenticationService _authenticationService;

  FredericUser user;

  AuthenticationService get authService => _authenticationService;

  // ===========================================================================
  /// Gets all global activities and the activities of the current user
  ///
  /*
  Stream<List<FredericActivity>> getAllActivities([bool loadSets = false]) {
    CollectionReference activitiesCollection = FirebaseFirestore.instance.collection('activities');

    Stream<QuerySnapshot> globalStream = activitiesCollection
        .where('owner', isEqualTo: 'global')
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();

    List<FredericActivity> activities = List<FredericActivity>();

    for (int i = 0; i < snapshot.docs.length; i++) {
      var map = snapshot.docs[i];
      activities.add(FredericActivity(
          name: map['name'],
          description: map['description'],
          image: map['image'],
          owner: map['owner'],
          id: 'TODO: Impelment id'));
    }
    return activities;
  }

  // ===========================================================================
  /// Gets all activities of the currently logged in user
  ///
  Future<List<FredericActivity>> getUserActivities() async {
    CollectionReference activitiesCollection =
        FirebaseFirestore.instance.collection('activities');

    QuerySnapshot snapshot = await activitiesCollection
        .where('owner', isEqualTo: _firebaseAuth.currentUser.uid)
        .get();

    List<FredericActivity> activities = List<FredericActivity>();

    for (int i = 0; i < snapshot.docs.length; i++) {
      var map = snapshot.docs[i];
      activities.add(FredericActivity(
          name: map['name'],
          description: map['description'],
          image: map['image'],
          owner: map['owner'],
          id: 'TODO: IMPLEMENT id'));
    }
    return activities;
  }
  */

  // ===========================================================================
  /// updates the local userdata with new data from firebase
  ///
  Future<FredericUser> reloadUserData() {
    user = FredericUser(_firebaseAuth.currentUser);
    return user.loadData();
  }

  //Future<FredericWorkout> getCurrentWorkout() async {}
}
