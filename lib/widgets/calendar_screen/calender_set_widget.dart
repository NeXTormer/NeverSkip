import 'package:flutter/material.dart';

class CalendarSetWidget extends StatelessWidget {
  const CalendarSetWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Divider(),
        Row(
          children: [
            SizedBox(width: 54),
            Icon(Icons.arrow_forward_ios_outlined, size: 16),
            Text("60 sets with 50"),
            SizedBox(width: 4),
            Icon(
              Icons.fitness_center,
              size: 14,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Container(),
            ),
            Text("on 12.12.2020")
          ],
        )
      ],
    ));
  }
}
