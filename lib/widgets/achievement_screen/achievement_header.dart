import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';

class AchievementHeader extends StatelessWidget {
  const AchievementHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: theme.isColorful ? theme.mainColor : theme.backgroundColor,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
          child: Row(
            children: [
              Icon(
                ExtraIcons.dumbbell,
                color: theme.isColorful ? Colors.white : theme.mainColor,
              ),
              SizedBox(width: 32),
              Text(
                'Overview',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.isColorful ? Colors.white : theme.mainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(
//               ExtraIcons.dumbbell,
//               color: theme.mainColor,
//             ),
//             SizedBox(width: 32),
//             Text(
//               'Overview',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
