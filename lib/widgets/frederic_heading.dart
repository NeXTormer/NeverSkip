import 'package:flutter/material.dart';

class FredericHeading extends StatelessWidget {
  FredericHeading(this.text, {this.onPressed});

  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.6)),
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
