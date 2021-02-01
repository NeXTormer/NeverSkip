import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/widgets/calendar_screen/calendar_workout_widget.dart';
import 'package:frederic/widgets/show_workout_screen/workout_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../backend/backend.dart';

class ShowWorkoutScreen extends StatefulWidget {
  ShowWorkoutScreen({Key key}) : super(key: key);

  @override
  _ShowWorkoutScreenState createState() => _ShowWorkoutScreenState();
}

class _ShowWorkoutScreenState extends State<ShowWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    FredericUser user = FredericUser(FirebaseAuth.instance.currentUser.uid);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            centerTitle: true,
            title: Text('All Activities',
                style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(fontSize: 32))),
          ),
          FutureBuilder<FredericUser>(
            future: user.loadData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                FredericWorkout workout =
                    FredericWorkout(snapshot.data.currentWorkoutID);
                return FutureBuilder<FredericWorkout>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CalendarWorkoutWidget(workout: snapshot.data);
                      }
                      return SliverToBoxAdapter(
                          child: Text("Loading workout..."));
                    },
                    future: workout.loadData());
              }
              return SliverToBoxAdapter(child: Text("Loading user data..."));
            },
          )
        ],
      ),
    );
  }
}
