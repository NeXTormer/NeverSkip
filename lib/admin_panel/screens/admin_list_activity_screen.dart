import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frederic/admin_panel/widgets/admin_data_table.dart';
import 'package:frederic/admin_panel/widgets/admin_edit_activity_view.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/main.dart';

class AdminListActivityScreen extends StatefulWidget {
  const AdminListActivityScreen({Key? key}) : super(key: key);

  @override
  _AdminListActivityScreenState createState() =>
      _AdminListActivityScreenState();
}

class _AdminListActivityScreenState extends State<AdminListActivityScreen> {
  FredericActivity? highlightedActivity;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: Row(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: SingleChildScrollView(
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('activities')
                        .get(),
                    builder: (context, data) {
                      if (!data.hasData) return Container();
                      List<FredericActivity> activities = <FredericActivity>[];
                      for (var doc in data.data?.docs ??
                          <QueryDocumentSnapshot<Map<String, dynamic>>>[]) {
                        activities.add(FredericActivity(doc));
                      }
                      if (activities.isEmpty) return Container();
                      return AdminDataTable<FredericActivity>(
                          onSelectElement: (activity) {
                            print(activity);
                            setState(() {
                              if (highlightedActivity == null) {
                                highlightedActivity = activity;
                                expanded = true;
                                return;
                              }
                              if (highlightedActivity == activity) {
                                highlightedActivity = null;
                                expanded = false;
                                return;
                              } else {
                                highlightedActivity = activity;
                                expanded = true;
                                return;
                              }
                            });
                          },
                          elements: activities);
                    }),
              ),
            ),
          ),
          AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: expanded ? 450 : 0,
              child: expanded
                  ? AdminEditActivityView(
                      highlightedActivity!,
                      key: ValueKey<String>(highlightedActivity!.activityID),
                    )
                  : null)
        ],
      ),
    );
  }
}
