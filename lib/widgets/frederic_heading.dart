import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericHeading extends StatelessWidget {
  FredericHeading(this.heading, {this.onPressed, this.subHeading});

  final Function onPressed;
  final String heading;
  final String subHeading;

  @override
  Widget build(BuildContext context) {
    bool showsubheading = subHeading != null;
    return Column(
      children: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(heading,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: kTextColor,
                    letterSpacing: 0.6)),
            if (showsubheading) SizedBox(width: 8),
            if (showsubheading)
              Container(
                width: 1,
                height: 18,
                decoration: BoxDecoration(
                    color: const Color(0xFFCDCDCD),
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
            if (showsubheading) SizedBox(width: 8),
            if (showsubheading)
              Text(subHeading,
                  style: const TextStyle(
                      color: const Color(0xF2A5A5A5),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      letterSpacing: 0.6)),
            Expanded(child: Container()),
            if (onPressed != null)
              InkWell(
                onTap: onPressed,
                child: Icon(
                  Icons.menu,
                  color: const Color(0xFFC4C4C4),
                ),
              )
          ],
        )
      ],
    );
  }
}
