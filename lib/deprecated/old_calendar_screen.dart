import 'package:flutter/material.dart';
import 'package:frederic/widgets/second_design/calendar/calendar_and_events_view.dart';
import 'package:reorderables/reorderables.dart';

class CalendarScreen extends StatelessWidget {
  static const routeName = '/calendar';
  bool test = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: test
          ? SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CalendarAndEventsView(),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('hello'),
                  expandedHeight: 250,
                  flexibleSpace: FlexibleSpaceBar(
                    background: CalendarAndEventsView(),
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
                        //child: ActivityInWorkout(Key('$index')),
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
      //bottomNavigationBar: BottomNavDesign(1),
    );
  }
}
