import 'package:flutter/cupertino.dart';

class WorkoutSearchTerm with ChangeNotifier {
  WorkoutSearchTerm() : _searchTerm = '';

  String _searchTerm;

  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  String get searchTerm => _searchTerm;
}
