import 'package:flutter/cupertino.dart';

class PageViewBlocker extends ChangeNotifier {
  bool _scrollable = false;
  bool get scrollable => _scrollable;
  set scrollable(bool value) {
    _scrollable = value;
    notifyListeners();
  }
}
