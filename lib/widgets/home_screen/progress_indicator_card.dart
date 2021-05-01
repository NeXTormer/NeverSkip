import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

import '../picture_icon.dart';

class ProgressIndicatorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 130,
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
                Text(
                  'Bench Press',
                  style: const TextStyle(
                      color: const Color(0x7A3A3A3A),
                      fontSize: 10,
                      letterSpacing: 0.3),
                ),
                Row(
                  children: [
                    Text(
                      '220',
                      style: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontSize: 16),
                    ),
                    SizedBox(width: 2),
                    Text('kg',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            fontSize: 14))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
