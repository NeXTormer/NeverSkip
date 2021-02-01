import 'dart:io';
import 'package:flutter/material.dart';

class ProfileItem {
  final String name;
  String subText;
  File imageFile;

  ProfileItem(
    @required this.name,
    @required this.subText, [
    this.imageFile,
  ]);
}

class Profile with ChangeNotifier {
  ProfileItem _profile = ProfileItem('', '');

  void initializeProfile(String name, String subText, [File imageFile]) {
    _profile = ProfileItem(
      name,
      subText,
      imageFile == null ? null : imageFile,
    );
    notifyListeners();
  }

  ProfileItem getProfile() {
    return _profile;
  }

  void updateSubText(String newSubText) {
    _profile.subText = newSubText;
    notifyListeners();
  }
}
