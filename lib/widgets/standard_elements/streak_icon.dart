import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/main.dart';

class StreakIcon extends StatelessWidget {
  const StreakIcon(
      {Key? key, this.onColorfulBackground = false, required this.user})
      : super(key: key);

  final FredericUser user;
  final bool onColorfulBackground;

  @override
  Widget build(BuildContext context) {
    return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '${user.streak}',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: onColorfulBackground
                      ? theme.textColorColorfulBackground
                      : theme.textColor),
            ),
          ),
          SizedBox(width: 6),
          Icon(
            Icons.local_fire_department_outlined,
            color: theme.isDark
                ? theme.textColor
                : (onColorfulBackground
                    ? theme.textColorColorfulBackground
                    : theme.mainColor),
          )
        ],
      ),
    );
  }
}
