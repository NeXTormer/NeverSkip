import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/frederic_activity.dart';
import 'package:frederic/widgets/activity_screen/add_progress_card.dart';
import 'package:frederic/widgets/outlined_gradient_button.dart';

class ActivityCalendarCard extends StatefulWidget {
  final FredericActivity activityItem;
  final Key key;

  ActivityCalendarCard(this.activityItem, this.key);

  @override
  _ActivityCalendarCardState createState() => _ActivityCalendarCardState();
}

class _ActivityCalendarCardState extends State<ActivityCalendarCard> {
  int _reps = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 0,
            child: Container(
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return AddProgressCard(widget.activityItem, _reps);
                      });
                },
                child: Icon(Icons.more_horiz),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 0,
            child: Container(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(
                      icon: Icon(Icons.remove),
                      onTap: () {
                        setState(() {
                          if (_reps > 0) {
                            _reps--;
                          }
                        });
                      }),
                  Text('$_reps', style: TextStyle(fontSize: 18)),
                  _buildIconButton(
                      icon: Icon(Icons.add),
                      onTap: () {
                        _reps++;
                      }),
                ],
              ),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(widget.activityItem.image),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.activityItem.name,
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      //height: 50,
                      child: AutoSizeText(
                        widget.activityItem.description,
                        maxLines: 3,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({Icon icon, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: icon,
    );
  }
}
