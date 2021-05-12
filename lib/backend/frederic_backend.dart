import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frederic/backend/frederic_activity_manager.dart';
import 'package:frederic/backend/frederic_goal_manager.dart';
import 'package:frederic/backend/frederic_workout_manager.dart';
import 'package:frederic/main.dart';

import 'backend.dart';

///
/// Main class of the Backend. Manages everything related to storing and loading
/// data form the DB or the device, and handles sign in / sign up.
///
class FredericBackend {
  FredericBackend();

  Future<void> loadData() async {
    //TODO: wait until data loaded to complete
    _authenticationService = AuthenticationService(FirebaseAuth.instance);
    _activityManager = FredericActivityManager();
    _activityManager.loadData();
    await _activityManager.hasData();
    _workoutManager = FredericWorkoutManager();
    _workoutManager.loadData();
    _goalManager = FredericGoalManager();
    _goalManager.loadData();
    _currentUserCompleter = Completer<FredericUser>();
    _currentUser = FredericUser(FirebaseAuth.instance.currentUser?.uid);
  }

  late AuthenticationService _authenticationService;
  AuthenticationService get authService => _authenticationService;

  late final FredericActivityManager _activityManager;
  FredericActivityManager get activityManager => _activityManager;

  late final FredericWorkoutManager _workoutManager;
  FredericWorkoutManager get workoutManager => _workoutManager;

  late final FredericGoalManager _goalManager;
  FredericGoalManager get goalManager => _goalManager;

  late FredericUser _currentUser;
  FredericUser get currentUser => _currentUser;

  Stream<FredericUser>? _currentUserStream;
  Stream<FredericUser>? get currentUserStream => _currentUserStream;

  static FredericBackend get instance => getIt<FredericBackend>();

  late Completer<FredericUser> _currentUserCompleter;

  ///
  /// Use this to load the data for the currentUser, instead of using
  /// currentUser.loadData().
  ///
  /// Normally called in AuthenticationWrapper
  ///
  Future<FredericUser> loadCurrentUser() async {
    _loadCurrentUserStream();
    return _currentUserCompleter.future;
  }

  void logIn(String uid) {
    _currentUser!.uid = uid;
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
    dispose();
    if (getIt.isRegistered<FredericBackend>())
      getIt.unregister<FredericBackend>();
    getIt.registerSingleton<FredericBackend>(FredericBackend());
  }

  void _loadCurrentUserStream() {
    if (currentUser?.uid == null) return null;

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    Stream<DocumentSnapshot> userStream =
        usersCollection.doc(currentUser!.uid).snapshots();

    userStream.listen(_handleUserStream);
  }

  void _handleUserStream(DocumentSnapshot snapshot) {
    currentUser!.insertDocumentSnapshot(
        snapshot as DocumentSnapshot<Map<String, dynamic>>);
    if (!_currentUserCompleter.isCompleted)
      _currentUserCompleter.complete(currentUser);
  }

  void dispose() {
    _activityManager.dispose();
    _workoutManager.dispose();
    _goalManager.dispose();
  }
}
