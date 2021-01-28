import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/frederic_set.dart';
import 'package:frederic/widgets/calendar_screen/calendar_set_widget.dart';

class CalendarActivityWidget extends StatefulWidget {
  CalendarActivityWidget({Key key, @required this.activity}) : super(key: key);

  final FredericActivity activity;

  @override
  _CalendarActivityWidgetState createState() => _CalendarActivityWidgetState();
}

class _CalendarActivityWidgetState extends State<CalendarActivityWidget> {
  bool _extended = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: handleTap,
        child: AnimatedContainer(
            padding: EdgeInsets.all(8),
            duration: Duration(milliseconds: 140),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.activity.image),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.activity.name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.activity.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      VerticalDivider(thickness: 1),
                      SizedBox(width: 4),
                      Row(
                        children: [
                          Text('${widget.activity.bestWeight}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          SizedBox(width: 4),
                          Icon(
                            Icons.fitness_center,
                            size: 16,
                          )
                        ],
                      )
                    ],
                  ),
                  Column(children: _extended ? createSetList() : [])
                ],
              ),
            )),
      ),
    );
  }

  createSetList() {
    var sets = <Widget>[];
    widget.activity.sets.forEach((element) {
      sets.add(CalendarSetWidget(
        fredericSet: element,
      ));
    });
    return sets;
  }

  void handleTap() {
    setState(() {
      _extended = !_extended;
    });
  }
}
