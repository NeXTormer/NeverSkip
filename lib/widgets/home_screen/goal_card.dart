import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/picture_icon.dart';
import 'package:frederic/widgets/progress_bar.dart';

class GoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: kCardBorderColor)),
      child: Row(
        children: [
          PictureIcon(
              'https://firebasestorage.googleapis.com/v0/b/hawkford-frederic.appspot.com/o/defaultimages%2Fbench%4010x.png?alt=media&token=71255870-0a50-407d-a0b1-4a8a52a11bc3'),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 132,
                        child: Text(
                          'Bench Press like a Boss',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: const Color(0x7A3A3A3A),
                              fontSize: 10,
                              letterSpacing: 0.3),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                            color: kAccentColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Text(
                          '18 days',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              letterSpacing: 0.3),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Row(
                    children: [
                      Text(
                        '220',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 13),
                      ),
                      SizedBox(width: 2),
                      Text('kg',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 11)),
                      Expanded(child: Container()),
                      Text(
                        '220',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 13),
                      ),
                      SizedBox(width: 2),
                      Text('kg',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 11))
                    ],
                  ),
                ),
                ProgressBar(0.8)
              ],
            ),
          )
        ],
      ),
    );
  }
}
