import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/widgets/calendar_screen/calendar_activity_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AllActivitiesScreen extends StatelessWidget {
  const AllActivitiesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            centerTitle: true,
            title: Text('All Activities', style: GoogleFonts.varelaRound(textStyle: TextStyle(fontSize: 32))),
          ),
          FutureBuilder<List<FredericActivity>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return CalendarActivityWidget(activity: snapshot.data[index]);
                    }, childCount: snapshot.data.length),
                  );
                }
                return SliverToBoxAdapter(child: Text("Loading workout data..."));
              },
              future: FredericBackend.getAllActivities(true)),
        ],
      ),
    );
  }
}
