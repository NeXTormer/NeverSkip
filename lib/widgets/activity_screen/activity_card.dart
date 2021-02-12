import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/providers/activity.dart';
import 'package:provider/provider.dart';

class ActivityCard extends StatefulWidget {
  final FredericActivity activity;

  ActivityCard(this.activity);
  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  int _countReps = 0;
  bool _expanded = false;

  List<Container> buildShadow() {
    List<Container> output = [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          gradient: LinearGradient(
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
          image: NetworkImage(
            imgUrl,
          ),
        ),
      ),
    );
  }

  Widget buildTitleSection(String title, int subActivities) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 26.0, color: Colors.white),
        ),
        if (subActivities != 0)
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    child: _expanded
                        ? Icon(
                            Icons.expand_less,
                            color: Colors.white,
                            size: 26.0,
                          )
                        : Icon(
                            Icons.expand_more,
                            color: Colors.white,
                            size: 26.0,
                          ),
                  )),
              Text(
                subActivities.toString(),
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
      ],
    );
  }

  Widget buildAddSection() {
    return Container(
      width: 100,
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
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Icon(
                Icons.remove,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                _countReps.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              width: 25,
              height: 25,
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
        margin: EdgeInsets.all(16.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: tagList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subActivites = Provider.of<Activity>(context, listen: false)
        .getActivitiesOfOwner(widget.activity.activityID);

    return Column(
      children: [
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          closeOnScroll: true,
          actions: [
            IconSlideAction(
              iconWidget: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 4, top: 4, bottom: 4),
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
                    Text(
                      "Add progress",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              color: Colors.transparent,
              closeOnTap: true,
              onTap: () {},
            ),
          ],
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
                        buildTitleSection(
                            widget.activity.name, subActivites.length),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildAddSection(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  buildLabelSection(),
                ],
              ),
            ),
          ),
        ),
        /*
        if (_expanded)
          ...subActivites.map(
            (activity) => ActivityCard(activity),
          ), */
      ],
    );
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
        color: Color.fromARGB(170, 255, 165, 0),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: Colors.orange,
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