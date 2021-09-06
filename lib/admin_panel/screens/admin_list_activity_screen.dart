import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/admin_panel/widgets/admin_data_table.dart';
import 'package:frederic/admin_panel/widgets/admin_edit_activity_view.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/activities/frederic_activity_list_data.dart';
import 'package:frederic/backend/activities/frederic_activity_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';

class AdminListActivityScreen extends StatefulWidget {
  const AdminListActivityScreen({Key? key}) : super(key: key);

  @override
  _AdminListActivityScreenState createState() =>
      _AdminListActivityScreenState();
}

class _AdminListActivityScreenState extends State<AdminListActivityScreen> {
  FredericActivity? highlightedActivity;
  bool expanded = false;

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: Row(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  FredericBackend.instance.activityManager.reload(),
              child: SingleChildScrollView(
                child: BlocBuilder<FredericActivityManager,
                    FredericActivityListData>(builder: (context, activities) {
                  if (activities.activities.isEmpty) return Container();
                  return Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, right: 16, left: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: FredericTextField('Search by Name',
                                    controller: searchController,
                                    onSubmit: (text) => setState(() {}),
                                    icon: Icons.image_search)),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchController.text = '';
                                });
                              },
                              child: Icon(
                                Icons.highlight_remove_outlined,
                                color: kMainColor,
                              ),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  highlightedActivity =
                                      FredericActivity.template();
                                  expanded = true;
                                });
                              },
                              child: Icon(
                                Icons.add_chart,
                                color: kMainColor,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      AdminDataTable<FredericActivity>(
                          selectedElement: highlightedActivity,
                          onSelectElement: (activity) {
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
                          elements: activities.activities.values.toList()),
                    ],
                  );
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
