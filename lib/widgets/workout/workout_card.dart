import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_workout.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/widgets/workout/add_workout_card.dart';
import 'package:share/share.dart';

class WorkoutCard extends StatefulWidget {
  WorkoutCard(this.workout);

  final FredericWorkout workout;

  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  static bool _isActive = false;

  FredericUser user;

  String _shareText = 'https://orf.at';

  @override
  Widget build(BuildContext context) {
    user = FredericBackend.of(context).currentUser;
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          widget.workout.loadActivities();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditWorkoutScreen(widget.workout)));
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                    child: Image.network(
                      widget.workout.image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.workout.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.workout.description,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Created by: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.workout.ownerName,
                          )
                        ],
                      ),
                    ),
                    _buildActiveStatusButton(),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 10,
              top: 10,
              child: InkWell(
                onTap: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(_shareText,
                      subject: 'share workout',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.share,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddWorkoutCard(widget.workout),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveStatusButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _isActive = !_isActive;
        });
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Active: '),
            _isActive == true
                ? Icon(
                    Icons.done_all,
                    color: Colors.greenAccent[400],
                  )
                : const Icon(
                    Icons.clear,
                    color: Colors.red,
                  )
          ],
        ),
      ),
    );
  }
}
