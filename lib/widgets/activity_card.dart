import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/picture_icon.dart';

class ActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: kCardBorderColor)),
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            PictureIcon(
                'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/defaultimages%2Fbench%4010x.png?alt=media&token=71255870-0a50-407d-a0b1-4a8a52a11bc3'),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(children: [
                    Text('Muscle Ups'),
                    Expanded(child: Container()),
                    Text('220 kg')
                  ]),
                  Row(
                    children: [
                      Text('20 reps | 3 sets'),
                      Expanded(
                        child: Container(),
                      ),
                      Text('...')
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
