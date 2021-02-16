import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';

class ActivityInWorkout extends StatefulWidget {
  final FredericActivity activity;
  ActivityInWorkout(this.activity);
  @override
  _ActivityInWorkoutState createState() => _ActivityInWorkoutState();
}

class _ActivityInWorkoutState extends State<ActivityInWorkout> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Push-Up',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'Placeholder Text',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black,
                            ),
                          ),
                          child: Text(
                            '5',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.add),
                              SizedBox(height: 10),
                              Icon(Icons.delete),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.drag_handle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
