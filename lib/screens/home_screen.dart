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

    FredericActivity a = FredericActivity('0J8B5ByMcar6InMY7aQb');

    FredericWorkout workout = FredericWorkout('kKOnczVnBbBHvmx96cjG', true, true);
    workout.asStream().listen((value) {
      print('=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
      print(value.toString());
    });

    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            color: Colors.yellow,
          ),
          Container(
              child: StreamBuilder(
                  stream: a.asStream(),
                  builder: (BuildContext context, AsyncSnapshot<FredericActivity> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(
                        child: Text(snapshot.data.name),
                      ),
                    );
                  })),
          Text(
            "Username: ${fUser.name}",
            style: TextStyle(color: Colors.red),
          ),
          MaterialButton(
            child: Text("change name"),
            onPressed: () {
              a.name = "Werner Mosers Sitzposition";
            },
            color: Colors.red,
          ),
          MaterialButton(
            child: Text("Logout"),
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
