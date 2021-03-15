import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class UserFeedbackToast {
  final fToast = FToast();
  final textStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  final boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.black.withAlpha(50),
  );

  showAddedToast(BuildContext context) {
    fToast.init(context);
    fToast.showToast(
      gravity: ToastGravity.CENTER,
      child: Container(
        width: 100,
        height: 100,
        decoration: boxDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              size: 70,
              color: Colors.white,
            ),
            Text(
              'Added',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  showProgressAddedToast(BuildContext context) {
    fToast.init(context);
    fToast.showToast(
      gravity: ToastGravity.CENTER,
      child: Container(
        decoration: boxDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Added Progress',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
