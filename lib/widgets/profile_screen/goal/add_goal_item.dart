import 'package:flutter/material.dart';

class AddGoalItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new Goal'),
      content: Container(
        width: 1000,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image.network(
                'https://www.namepros.com/attachments/empty-png.89209/',
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextField(),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: TextField(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Create'),
        )
      ],
    );
  }
}
