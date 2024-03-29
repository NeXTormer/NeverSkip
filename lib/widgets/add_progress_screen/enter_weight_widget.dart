import 'package:flutter/material.dart';
import 'package:frederic/widgets/add_progress_screen/small_text_card.dart';
import 'package:provider/provider.dart';

import 'add_progress_card.dart';

class EnterWeightWidget extends StatelessWidget {
  const EnterWeightWidget({Key? key, this.onTap}) : super(key: key);

  final void Function()? onTap;

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
          SmallTextCard('-5',
              width: 60, height: 42, onTap: () => handleButton(-5, controller)),
          SmallTextCard(
            '${controller.weight.floor().toDouble() == controller.weight ? controller.weight.toInt() : controller.weight}',
            width: 76,
            height: 42,
            textSize: 20,
            selected: true,
            onLongPress: () {},
          ),
          SmallTextCard('+5',
              width: 60, height: 42, onTap: () => handleButton(5, controller)),
          SmallTextCard('+1',
              width: 60, height: 42, onTap: () => handleButton(1, controller))
        ],
      ));
    });
  }

  void handleButton(double change, AddProgressController controller) {
    final newWeight = controller.weight + change;
    if (newWeight < 0) {
      controller.weight = 0;
    } else {
      controller.weight = newWeight;
    }
    onTap?.call();
  }
}
