import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
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
    FredericActivity a = FredericActivity('f1D90ciK78F5nBhSt7Zw');
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
          CalendarWorkoutWidget(),
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("loaded data shcuubbb");
                return CalendarActivityWidget(activity: snapshot.data);
              }
              return SliverToBoxAdapter(child: Container());
            },
            future: a.loadData(true),
          )
        ],
      ),
    );
  }
}
