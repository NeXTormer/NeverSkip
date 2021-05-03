import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/frederic_vertical_divider.dart';
import 'package:frederic/widgets/picture_icon.dart';
import 'package:google_fonts/google_fonts.dart';

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Text('Bench press',
                            style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: true
                                    ? kTextColor
                                    : const Color(0x993A3A3A))),
                        Expanded(child: Container()),
                        Icon(ExtraIcons.dumbbell, color: kMainColor, size: 18),
                        SizedBox(width: 6),
                        Text(
                          '220',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              fontSize: 14),
                        ),
                        SizedBox(width: 2),
                        Text('kg',
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                fontSize: 12)),
                      ]),
                  Row(
                    children: [
                      Text(
                        '20',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 14),
                      ),
                      SizedBox(width: 2),
                      Text('reps',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12)),
                      SizedBox(width: 6),
                      FredericVerticalDivider(length: 16),
                      SizedBox(width: 6),
                      Text(
                        '3',
                        style: TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 14),
                      ),
                      SizedBox(width: 2),
                      Text('sets',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 12)),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(ExtraIcons.dots, color: kGreyColor, size: 20)
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
