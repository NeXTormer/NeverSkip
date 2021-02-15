import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/backend/frederic_workout.dart';

class BackendTestScreen extends StatelessWidget {
  const BackendTestScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FredericWorkout w = FredericWorkout('wCiDw2K3mV30ro6HGlfj', true, true);
    w.loadData().then((value) {
      FredericActivity a = FredericActivity('0J8B5ByMcar6InMY7aQb');
      a.loadData().then((value) {
        print(w);
      });
    });

    return Scaffold(
      body: Container(color: Colors.red, height: 400),
    );
  }
}
