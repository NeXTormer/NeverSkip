import 'package:flutter/material.dart';
import 'package:frederic/widgets/add_progress_screen/small_text_card.dart';
import 'package:provider/provider.dart';

import 'add_progress_card.dart';

class EnterRepsCounterWidget extends StatelessWidget {
  const EnterRepsCounterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProgressController>(
        builder: (context, controller, child) {
      return Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SmallTextCard('-1',
              width: 60, height: 42, onTap: () => handleButton(-1, controller)),
          SmallTextCard('-2',
              width: 60, height: 42, onTap: () => handleButton(-2, controller)),
          SmallTextCard(
            '${controller.reps}',
            width: 76,
            height: 42,
            textSize: 20,
            selected: true,
            onLongPress: () {},
          ),
          SmallTextCard('+2',
              width: 60, height: 42, onTap: () => handleButton(2, controller)),
          SmallTextCard('+1',
              width: 60, height: 42, onTap: () => handleButton(1, controller))
        ],
      ));
    });
  }

  void handleButton(int change, AddProgressController controller) {
    final newValue = controller.reps + change;
    if (newValue < 0) {
      controller.reps = 0;
    } else {
      controller.reps = newValue;
    }
  }
}
