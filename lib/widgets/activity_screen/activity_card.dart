import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/activity_screen/add_progress_card.dart';

///
/// [selectable]: widget can be added to a workout
/// [dismissible]: widget can be removed from a workout
/// neither: widget can be clicked on to add progress
///
class ActivityCard extends StatefulWidget {
  ActivityCard(this.activity,
      {this.selectable = false,
      this.onAddActivity,
      this.dismissible = false,
      this.onDismiss});

  final bool selectable;
  final bool dismissible;
  final FredericActivity activity;
  final Function(FredericActivity) onAddActivity;
  final Function(FredericActivity) onDismiss;

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  int _countReps = 0;
  bool _expanded = false;

  @override
  void initState() {
    _countReps = widget.activity.recommendedReps;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4, left: 6, right: 6),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.3,
        closeOnScroll: true,
        secondaryActions: widget.dismissible
            ? [buildDeleteButton()]
            : (widget.selectable ? [buildAddButton()] : []),
        child: Card(
          elevation: 5.0,
          child: Container(
            height: 100,
            //margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Stack(
              children: [
                buildBackgroundImage(widget.activity.image),
                ...buildShadow(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTitleSection(widget.activity.name),
                    ],
                  ),
                ),
                buildLabelSection(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.black12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5.0),
                        border:
                            Border.all(color: Colors.transparent, width: 0.5),
                      ),
                    ),
                    onTap: widget.selectable || widget.dismissible
                        ? null
                        : () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return AddProgressCard(
                                      widget.activity, _countReps);
                                });
                          },
                  ),
                ),
                Positioned(top: 16, right: 16, child: buildAddSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Container> buildShadow() {
    List<Container> output = [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          gradient: true
              ? RadialGradient(
                  colors: [const Color(0x0C000000), const Color(0x00000000)],
                  radius: 10,
                  focalRadius: 10,
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0x0C000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0x0C000000),
                  ],
                ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xCC000000),
              const Color(0x00000000),
              const Color(0x00000000),
              const Color(0xCC000000),
            ],
          ),
        ),
      ),
    ];
    return output;
  }

  Widget buildBackgroundImage(String imgUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(imgUrl),
        ),
      ),
    );
  }

  Widget buildTitleSection(String title) {
    return Container(
      width: 300,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 26.0, color: Colors.white),
      ),
    );
  }

  Widget buildAddSection() {
    return widget.selectable || widget.dismissible
        ? Container()
        : Container(
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (_countReps != 0) {
                      setState(() {
                        _countReps--;
                      });
                    }
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Icon(
                      Icons.remove,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      _countReps.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _countReps++;
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildLabelSection() {
    List<Widget> tagList = List<Widget>();
    for (var value in widget.activity.muscleGroups) {
      String label = '';
      switch (value) {
        case FredericActivityMuscleGroup.Abs:
          label = 'Abs';
          break;
        case FredericActivityMuscleGroup.Chest:
          label = 'Chest';
          break;
        case FredericActivityMuscleGroup.Arms:
          label = 'Arms';
          break;
        case FredericActivityMuscleGroup.Legs:
          label = 'Legs';
          break;
        case FredericActivityMuscleGroup.Back:
          label = 'Back';
          break;
      }
      tagList.add(MuscleGroupTag(label));
    }

    return Positioned(
      bottom: 0.0,
      right: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: tagList),
      ),
    );
  }

  Widget buildAddButton() {
    return IconSlideAction(
      iconWidget: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.green,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            if (widget.selectable)
              Text(
                "Add to",
                style: TextStyle(color: Colors.white),
              ),
            if (widget.selectable)
              Text(
                "workout",
                style: TextStyle(color: Colors.white),
              )
          ],
        ),
      ),
      color: Colors.transparent,
      closeOnTap: true,
      onTap: () {
        if (widget.selectable) {
          widget.onAddActivity(widget.activity);
        }
      },
    );
  }

  Widget buildDeleteButton() {
    return IconSlideAction(
        iconWidget: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.red,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outlined,
                color: Colors.white,
              ),
              Text(
                "Delete from",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "workout",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        color: Colors.transparent,
        closeOnTap: true,
        onTap: () => widget.onDismiss(widget.activity));
  }
}

class MuscleGroupTag extends StatelessWidget {
  const MuscleGroupTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: kMainColor, //Color.fromARGB(170, 255, 165, 0),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: Colors.white54,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
