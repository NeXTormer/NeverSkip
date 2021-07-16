import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';

class WorkoutCard extends StatefulWidget {
  const WorkoutCard(this.workout, {Key? key}) : super(key: key);

  final FredericWorkout workout;

  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool isSelected = false;
  bool isRepeating = false;

  @override
  void initState() {
    isSelected = FredericBackend.instance.userManager.state.activeWorkouts
        .contains(widget.workout.workoutID);
    isRepeating = widget.workout.repeating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      height: 80,
      child: true
          ? Material(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topLeft: Radius.circular(8))),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.workout.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            SizedBox(height: 6),
                            Text(
                              widget.workout.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          ]),
                    ),
                  )),
                  FredericVerticalDivider(
                    length: 110,
                    thickness: 0.6,
                  ),
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    onTap: () {
                      setState(() {
                        List<String> activeWorkouts = FredericBackend
                            .instance.userManager.state.activeWorkouts;
                        if (activeWorkouts.contains(widget.workout.workoutID)) {
                          activeWorkouts.remove(widget.workout.workoutID);
                          if (isSelected) isSelected = false;
                        } else {
                          activeWorkouts.add(widget.workout.workoutID);
                          if (!isSelected) isSelected = true;
                        }
                        FredericBackend.instance.userManager.activeWorkouts =
                            activeWorkouts;
                      });
                    },
                    child: Container(
                      width: 84,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '3 Weeks',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (isRepeating)
                                  Icon(Icons.repeat_outlined,
                                      color: kMainColor),
                                Expanded(child: Container()),
                                Icon(
                                  isSelected
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank_outlined,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // PictureIcon(
                      //     'https://www.holzdiesonne.net/fileadmin/_processed_/f/9/csm_Portrait-Werner-Findenig_82b6dca0e5.png'),
                      // SizedBox(width: 8),
                      Text(
                        'Bring sally up challenge',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.check),
                      Icon(
                        Icons.repeat_outlined,
                        color: kMainColor,
                      ),
                      Text('3 Weeks')
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Bring sally up challenge Bring sally up challenge Bring sally up challenge Bring sally up challenge Bring sally up challenge',
                      maxLines: 2,
                    ))
              ],
            ),
    );
  }
}
