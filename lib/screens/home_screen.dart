import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/backend/frederic_backend.dart';
import 'package:frederic/backend/frederic_user.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FredericBackend backend = context.watch<FredericBackend>();
    test(backend);

    User user = context.watch<User>();
    FredericUser fUser = FredericUser(user);

    FredericWorkout workout = FredericWorkout('wCiDw2K3mV30ro6HGlfj');
    workout.loadData().then((value) {
      print(workout.toString());
    });

    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Username: ${fUser.name}",
            style: TextStyle(color: Colors.red),
          ),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            color: Colors.red,
          )
        ],
      ),
    );
  }

  Future<void> test(FredericBackend backend) async {
    //List<FredericActivity> a = await backend.getUserActivities();
    //print(a[0].toString());
  }
}
