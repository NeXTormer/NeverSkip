import 'package:flutter/material.dart';
import 'package:frederic/widgets/add_progress_screen/small_text_card.dart';

import 'add_progress_card.dart';

class EnterRepsSliderWidget extends StatefulWidget {
  const EnterRepsSliderWidget({Key? key, required this.controller})
      : super(key: key);

  final AddProgressController controller;

  @override
  _EnterRepsSliderWidgetState createState() => _EnterRepsSliderWidgetState();
}

class _EnterRepsSliderWidgetState extends State<EnterRepsSliderWidget> {
  int selectedIndex = 0;
  late ScrollController scrollController;

  @override
  void initState() {
    final elementSize = 50 + 8;
    selectedIndex = 6;
    num offset = selectedIndex * elementSize;
    if (offset > elementSize * 4) {
      offset -= elementSize * 2.5;
    } else {
      offset = 0;
    }
    scrollController = ScrollController(initialScrollOffset: offset.toDouble());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 42,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 99,
          controller: scrollController,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SmallTextCard(
                  '${index + 1}',
                  height: 42,
                  width: 50,
                  selected: selectedIndex == index,
                  onTap: () => setState(() {
                    selectedIndex = index;
                    widget.controller.reps = index + 1;
                  }),
                ));
          },
        ));
  }
}
