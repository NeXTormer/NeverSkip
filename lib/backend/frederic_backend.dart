import 'package:firebase_auth/firebase_auth.dart';
import 'backend.dart';

class FredericBackend {
  FredericBackend(this._firebaseAuth)
      : _authenticationService = AuthenticationService(_firebaseAuth);

  final FirebaseAuth _firebaseAuth;
  final AuthenticationService _authenticationService;

  AuthenticationService get authService => _authenticationService;

  Future<List<FredericActivity>> getPublicActivities() async {}
}
