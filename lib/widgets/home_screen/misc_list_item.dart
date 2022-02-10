import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class MiscListItem extends StatelessWidget {
  const MiscListItem(
      {required this.text, this.onTap, this.icon = Icons.menu, Key? key})
      : super(key: key);

  final IconData icon;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      padding: const EdgeInsets.all(8),
      onTap: onTap,
      height: 55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.mainColorLight),
              child: Center(child: Icon(icon, color: theme.mainColorInText)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: theme.textColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  fontSize: 15),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: theme.greyColor,
          )
        ],
      ),
    );
  }
}
