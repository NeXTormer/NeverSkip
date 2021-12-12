import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/add_progress_screen/enter_reps_counter_widget.dart';
import 'package:frederic/widgets/add_progress_screen/enter_weight_widget.dart';
import 'package:frederic/widgets/add_progress_screen/reps_weight_smart_suggestions.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/set_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AddProgressScreen extends StatefulWidget {
  AddProgressScreen(this.activity, {this.openedFromCalendar = false}) {
    FredericBackend.instance.analytics.analytics
        .setCurrentScreen(screenName: 'add-progress-screen');
  }

  final bool openedFromCalendar;

  final FredericActivity activity;

  @override
  State<AddProgressScreen> createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  final AddProgressController controller = AddProgressController(0, 0);

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
                      'Exercise Progress',
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
                          'Save',
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
                    next.hasChanged(widget.activity.activityID),
                builder: (context, setListData) {
                  List<FredericSet> sets =
                      setListData[widget.activity.activityID].getLatestSets();
                  if (sets.isEmpty) {
                    controller.setRepsAndWeight(RepsWeightSuggestion(
                        widget.activity.recommendedReps, 30));
                  } else {
                    controller.setRepsAndWeight(
                        RepsWeightSuggestion(sets[0].reps, sets[0].weight));
                  }
                  List<RepsWeightSuggestion> suggestions =
                      setListData[widget.activity.activityID].getSuggestions(
                          weighted: widget.activity.type ==
                              FredericActivityType.Weighted,
                          recommendedReps: widget.activity.recommendedReps);
                  return CustomScrollView(
                    physics: ClampingScrollPhysics(),
                    controller: ModalScrollController.of(context),
                    slivers: [
                      SliverPadding(padding: EdgeInsets.only(bottom: 12)),
                      _DisplayActivityCard(widget.activity),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16),
                        child: FredericHeading('Current Performance'),
                      )),
                      ChangeNotifierProvider<AddProgressController>.value(
                        value: controller,
                        child: SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: theme.cardBackgroundColor,
                                border:
                                    Border.all(color: theme.cardBorderColor)),
                            child: Column(
                              children: [
                                buildSubHeading(
                                    'Repetitions', Icons.repeat_outlined),
                                SizedBox(height: 12),
                                EnterRepsCounterWidget(),
                                if (widget.activity.type ==
                                    FredericActivityType.Weighted) ...[
                                  SizedBox(height: 12),
                                  buildSubHeading(
                                      'Weight', ExtraIcons.dumbbell),
                                  SizedBox(height: 12),
                                  EnterWeightWidget(),
                                ],
                                SizedBox(height: 8),
                                buildSubHeading('Smart Suggestions',
                                    Icons.smart_button_outlined),
                                SizedBox(height: 8),
                                RepsWeightSmartSuggestions(suggestions),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 16),
                                  child: FredericButton('Save', onPressed: () {
                                    saveData();
                                    Navigator.of(context).pop();
                                  }),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16),
                        child: FredericHeading('Previous Performance'),
                      )),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  SetCard(sets[index], widget.activity),
                              childCount: sets.length)),
                      SliverToBoxAdapter(child: SizedBox(height: 12))
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

    FredericBackend.instance.setManager.addSet(
        widget.activity.activityID, FredericSet(reps, weight, DateTime.now()));

    if (widget.openedFromCalendar) {
      FredericBackend.instance.analytics.logAddProgressOnCalendar();
    } else {
      FredericBackend.instance.analytics.logAddProgressOnActivity();
    }
  }

  Widget buildSubHeading(String title, IconData icon) {
    return Row(
      children: [
        SizedBox(height: 24, width: 24, child: Icon(icon)),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: theme.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class AddProgressController extends ChangeNotifier {
  AddProgressController(int reps, double weight)
      : //_sets = sets,
        _reps = reps,
        _weight = weight;

  set reps(int value) {
    _reps = value;
    notifyListeners();
  }

  set weight(double value) {
    _weight = value;
    notifyListeners();
  }

  int get reps => _reps;
  double get weight => _weight;

  void setRepsAndWeight(RepsWeightSuggestion suggestion) {
    _reps = suggestion.reps;
    _weight = suggestion.weight ?? 0;
    notifyListeners();
  }

  //int _sets;
  int _reps;
  double _weight;
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
                Text(widget.activity.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: theme.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                SizedBox(height: 4),
                Flexible(
                  child: Text(widget.activity.description,
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
