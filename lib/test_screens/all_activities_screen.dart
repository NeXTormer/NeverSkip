import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/widgets/calendar_screen/calendar_activity_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AllActivitiesScreen extends StatefulWidget {
  AllActivitiesScreen({Key key}) : super(key: key);

  @override
  _AllActivitiesScreenState createState() => _AllActivitiesScreenState();
}

class _AllActivitiesScreenState extends State<AllActivitiesScreen> {
  StreamController<List<FredericActivity>> controller;

  @override
  Widget build(BuildContext context) {
    controller = FredericBackend.getAllActivitiesStream();
    Stream<List<FredericActivity>> activitiesStream = controller.stream;

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
          StreamBuilder<List<FredericActivity>>(
            stream: activitiesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return CalendarActivityWidget(activity: snapshot.data[index]);
                }, childCount: snapshot.data.length));
              }
              return SliverToBoxAdapter(child: Text('loading stream'));
            },
          ),
          SliverPadding(padding: EdgeInsets.only(top: 22)),
          FutureBuilder<List<FredericActivity>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return CalendarActivityWidget(
                          activity: snapshot.data[index]);
                    }, childCount: snapshot.data.length),
                  );
                }
                return SliverToBoxAdapter(
                    child: Text("Loading activity data..."));
              },
              future: FredericBackend.getAllActivities()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
