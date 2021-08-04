import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/main.dart';

class StreakIcon extends StatelessWidget {
  const StreakIcon({Key? key, required this.user}) : super(key: key);

  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '${user.currentStreak}',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
            ),
          ),
          SizedBox(width: 6),
          Icon(
            Icons.local_fire_department_outlined,
            color: kMainColor,
          )
        ],
      ),
    );
  }
}
