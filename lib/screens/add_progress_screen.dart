import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_list_data.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/add_progress_screen/add_progress_card.dart';
import 'package:frederic/widgets/add_progress_screen/previous_sets_list.dart';
import 'package:frederic/widgets/add_progress_screen/reps_weight_smart_suggestions.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class AddProgressScreen extends StatefulWidget {
  AddProgressScreen(this.activity, {this.openedFromCalendar = false}) {
    FredericBackend.instance.analytics.logCurrentScreen('add-progress-screen');
  }

  final bool openedFromCalendar;

  final bool enableSmartSuggestions = false;

  final FredericActivity activity;

  @override
  State<AddProgressScreen> createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  final AddProgressController controller = AddProgressController(0, 0);

  bool lastUsedSmartSuggestions = false;
  bool lastUsedRepsWeight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          Container(
            color: theme.isColorful ? theme.mainColor : theme.backgroundColor,
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 12, left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    ExtraIcons.statistics,
                    color: theme.isColorful
                        ? theme.textColorColorfulBackground
                        : theme.mainColor,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      tr('progress.add_progress_title'),
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: theme.textColorColorfulBackground,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          saveData();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          tr('save'),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: theme.isColorful
                                  ? theme.textColorColorfulBackground
                                  : theme.mainColor,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (theme.isMonotone)
            Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFFC9C9C9), width: 0.2)),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<FredericSetManager, FredericSetListData>(
                buildWhen: (current, next) =>
                    next.hasChanged(widget.activity.id),
                builder: (context, setListData) {
                  List<FredericSet> sets =
                      setListData[widget.activity.id].getLatestSets(0, 4);
                  if (sets.isEmpty) {
                    controller.setRepsAndWeight(RepsWeightSuggestion(
                        widget.activity.recommendedReps, 30));
                  } else {
                    controller.setRepsAndWeight(
                        RepsWeightSuggestion(sets[0].reps, sets[0].weight));
                  }
                  List<RepsWeightSuggestion>? suggestions =
                      widget.enableSmartSuggestions
                          ? setListData[widget.activity.id].getSuggestions(
                              weighted: widget.activity.type ==
                                  FredericActivityType.Weighted,
                              recommendedReps: widget.activity.recommendedReps)
                          : null;
                  return CustomScrollView(
                    physics: ClampingScrollPhysics(),
                    primary: true,
                    slivers: [
                      SliverPadding(padding: EdgeInsets.only(bottom: 12)),
                      _DisplayActivityCard(widget.activity),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16),
                        child: FredericHeading.translate(
                            'progress.current_performance'),
                      )),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AddProgressCard(
                              controller: controller,
                              activity: widget.activity,
                              onSave: (bool longPress) {
                                saveData();
                                if (!longPress) Navigator.of(context).pop();
                              },
                              onUseSmartSuggestions: () {
                                lastUsedRepsWeight = false;
                                lastUsedSmartSuggestions = true;
                              },
                              onUseRepsWeight: () {
                                lastUsedSmartSuggestions = false;
                                lastUsedRepsWeight = true;
                              },
                              suggestions: suggestions),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16),
                        child: FredericHeading.translate(
                            'progress.previous_performance'),
                      )),
                      PreviousSetsList(sets: sets, activity: widget.activity),
                      SliverToBoxAdapter(child: SizedBox(height: 50))
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  void saveData() {
    int reps = controller.reps;
    double weight = controller.weight;

    FredericBackend.instance.setManager
        .addSet(widget.activity, FredericSet(reps, weight, DateTime.now()));
    print(lastUsedSmartSuggestions);
    if (widget.openedFromCalendar) {
      FredericBackend.instance.analytics
          .logAddProgressOnCalendar(lastUsedSmartSuggestions);
    } else {
      FredericBackend.instance.analytics
          .logAddProgressOnActivity(lastUsedSmartSuggestions);
    }
  }
}

class _DisplayActivityCard extends StatefulWidget {
  const _DisplayActivityCard(this.activity, {Key? key}) : super(key: key);

  final FredericActivity activity;

  @override
  __DisplayActivityCardState createState() => __DisplayActivityCardState();
}

class __DisplayActivityCardState extends State<_DisplayActivityCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: FredericCard(
      animated: true,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(10),
      height: expanded ? 142 : 80,
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Row(
        children: [
          AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: expanded ? 0 : 60,
              height: double.infinity,
              child: LayoutBuilder(builder: (context, constraints) {
                return ConstrainedBox(
                    constraints: constraints,
                    child: PictureIcon(widget.activity.image,
                        mainColor: theme.mainColorInText));
              })),
          AnimatedPadding(
              padding: EdgeInsets.symmetric(horizontal: expanded ? 0 : 6),
              duration: Duration(milliseconds: 200)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    widget.activity
                        .getNameLocalized(context.locale.languageCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: theme.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                SizedBox(height: 4),
                Flexible(
                  child: Text(
                      widget.activity
                          .getDescriptionLocalized(context.locale.languageCode),
                      maxLines: expanded ? 6 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: theme.textColor,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          fontSize: 13)),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
