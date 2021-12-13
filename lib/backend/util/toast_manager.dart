import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

class ToastManager {
  ToastManager();
  final FToast _loginLoadingToast = FToast();

  final textStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: theme.mainColor.withAlpha(220) // Colors.black.withAlpha(50),
      );

  void showLoginLoadingToast(BuildContext context) {
    _loginLoadingToast.init(context);
    _loginLoadingToast.showToast(
      toastDuration: Duration(seconds: 10),
      gravity: ToastGravity.CENTER,
      child: Container(
        decoration: boxDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.textColorColorfulBackground,
            ),
            SizedBox(width: 10),
            Text(
              'Loading...',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  void removeLoginLoadingToast(BuildContext context) {
    _loginLoadingToast.removeQueuedCustomToasts();
    _loginLoadingToast.removeCustomToast();
  }
}
