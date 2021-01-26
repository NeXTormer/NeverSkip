import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/widgets/calendar_screen/calendar_activity_widget.dart';
import 'package:frederic/widgets/calendar_screen/calendar_workout_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    FredericWorkout w = FredericWorkout('kKOnczVnBbBHvmx96cjG');
    Stream<FredericWorkout> stream = w.asStream();
    var broadcast = stream.asBroadcastStream();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            centerTitle: true,
            title: Text('Todays Workout', style: GoogleFonts.varelaRound(textStyle: TextStyle(fontSize: 32))),
          ),
          StreamBuilder<FredericWorkout>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CalendarWorkoutWidget(workout: snapshot.data);
                }
                return SliverToBoxAdapter(child: Text("Loading..."));
              },
              stream: broadcast),
          StreamBuilder<FredericWorkout>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return CalendarActivityWidget(activity: snapshot.data.activities.today[index]);
                      },
                      childCount: snapshot.data.activities.today.length,
                    ),
                  );
                }
                return SliverToBoxAdapter(child: Text('Loading...'));
              },
              stream: broadcast)
        ],
      ),
    );
  }
}
