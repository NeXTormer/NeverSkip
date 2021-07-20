import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/number_slider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/set_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddProgressScreen extends StatelessWidget {
  AddProgressScreen(this.activity);

  final FredericActivity activity;

  final NumberSliderController repsSliderController = NumberSliderController();
  final NumberSliderController setsSliderController = NumberSliderController();
  final NumberSliderController weightSliderController =
      NumberSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 12, left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  ExtraIcons.statistics,
                  color: kMainColor,
                  size: 20,
                ),
                SizedBox(width: 12),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    'Exercise Progress',
                    style: GoogleFonts.montserrat(
                        color: kTextColor,
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
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Save',
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: kMainColor,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFC9C9C9), width: 0.2)),
          ),
          Expanded(
            child: CustomScrollView(
              physics: ClampingScrollPhysics(),
              controller: ModalScrollController.of(context),
              slivers: [
                SliverPadding(padding: EdgeInsets.only(bottom: 12)),
                _DisplayActivityCard(activity),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: FredericHeading('Current Performance'),
                )),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: kCardBorderColor)),
                    child: Column(
                      children: [
                        buildSubHeading('Reps', Icons.repeat_outlined),
                        SizedBox(height: 12),
                        NumberSlider(
                            controller: repsSliderController,
                            itemWidth: 0.14,
                            numberOfItems: 100,
                            startingIndex: activity.recommendedReps + 1),
                        SizedBox(height: 12),
                        buildSubHeading('Sets', Icons.account_tree_outlined),
                        SizedBox(height: 12),
                        NumberSlider(
                          controller: setsSliderController,
                          itemWidth: 0.14,
                          numberOfItems: 10,
                          startingIndex: 1,
                        ),
                        if (activity.type == FredericActivityType.Weighted) ...[
                          SizedBox(height: 12),
                          buildSubHeading('Weight', ExtraIcons.dumbbell),
                          SizedBox(height: 12),
                          NumberSlider(
                              controller: weightSliderController,
                              itemWidth: 0.14,
                              startingIndex: 56)
                        ], //TODO: set to average weight
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 0, right: 0, top: 16),
                          child: FredericButton('Save', onPressed: () {
                            int sets = setsSliderController.value.toInt();
                            int reps = repsSliderController.value.toInt();
                            int weight = weightSliderController.value.toInt();
                            for (int i = 0; i < sets; i++) {
                              FredericBackend.instance.setManager
                                  .state[activity.activityID]
                                  .addSet(FredericSet(
                                      reps, weight, DateTime.now()));
                            }
                            Navigator.of(context).pop();
                          }),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: FredericHeading('Previous Performance'),
                )),
                BlocBuilder<FredericSetManager, FredericSetListData>(
                    buildWhen: (current, next) =>
                        next.hasChanged(activity.activityID),
                    builder: (context, setListData) {
                      List<FredericSet> sets =
                          setListData[activity.activityID].getLatestSets();
                      return SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  //Container(height: 20, color: Colors.black26)
                                  SetCard(sets[index], activity),
                              childCount: sets.length));
                    }),
                SliverToBoxAdapter(child: SizedBox(height: 12))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubHeading(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: const Color(0x803A3A3A),
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
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
              //constraints: BoxConstraints(maxWidth: expanded ? 0 : 60),
              child: LayoutBuilder(builder: (context, constraints) {
                return ConstrainedBox(
                    constraints: constraints,
                    child: PictureIcon(widget.activity.image));
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
                    style: GoogleFonts.montserrat(
                        color: kMainColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                SizedBox(height: 4),
                Flexible(
                  child: Text(widget.activity.description,
                      maxLines: expanded ? 6 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          color: const Color(0xFF3A3A3A),
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
