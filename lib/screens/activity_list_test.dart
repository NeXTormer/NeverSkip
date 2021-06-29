import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/standard_elements/activity_card.dart';

class TestActivityList extends StatelessWidget {
  const TestActivityList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 60),
            Text('Activity List'),
            BlocBuilder<FredericActivityManager, FredericActivityListData>(
              builder: (context, listData) {
                return Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          height: 80,
                          child: ActivityCard(FredericBackend
                              .instance.activityManager.activities
                              .toList()[index]),
                        );
                      },
                      itemCount: FredericBackend
                          .instance.activityManager.activities.length),
                );
              },
              buildWhen: (last, current) => true,
            )
          ],
        ),
      ),
    );
  }
}
