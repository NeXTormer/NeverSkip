import 'package:flutter/material.dart';
import 'package:frederic/widget/second_design/activity/activity_in_workout.dart';
import 'package:frederic/widget/second_design/appbar/calender_felixble_appbar.dart';
import 'package:reorderables/reorderables.dart';

class CalenderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('hello'),
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: CalenderFlexibleAppbar(),
            ),
          ),
          ReorderableSliverList(
            delegate: ReorderableSliverChildBuilderDelegate(
              (ctx, index) => Container(
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(width: 0.2),
                //   ),
                // ),
                child: ActivityInWorkout(),
              ),
              childCount: 5,
            ),
            onReorder: (oldIndex, newIndex) {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Done',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        icon: Icon(
          Icons.done_all,
          color: Colors.greenAccent,
          size: 30,
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
          side: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
