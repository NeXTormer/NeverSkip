import 'package:flutter/material.dart';
import 'package:frederic/providers/goals.dart';

/// Clickable circle avatar with information of the [respectivly GoalItem]
///
/// Show various information of the [GoalItem] on tap.
/// currently show a static text.
class CircleItem extends StatelessWidget {
  final GoalItem goal;

  CircleItem(this.goal);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(goal.title),
                ),
              );
            },
            child: CircleAvatar(
              radius: 20,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue,
                          Colors.cyanAccent,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 19,
                      backgroundColor: Colors.white,
                      child: Text(
                        'S',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text('title'),
        ],
      ),
    );
  }
}
