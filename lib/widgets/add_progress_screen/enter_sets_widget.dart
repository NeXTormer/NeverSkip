import 'package:flutter/material.dart';
import 'package:frederic/widgets/add_progress_screen/small_text_card.dart';

import 'add_progress_card.dart';

class EnterSetsWidget extends StatefulWidget {
  const EnterSetsWidget({Key? key, required this.controller}) : super(key: key);

  final AddProgressController controller;

  @override
  _EnterSetsWidgetState createState() => _EnterSetsWidgetState();
}

class _EnterSetsWidgetState extends State<EnterSetsWidget> {
  int selected = 0;

  @override
  void initState() {
    //selected = widget.controller.sets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double elementWidth = 54;
      final double padding = 6;
      int count = (constraints.maxWidth) ~/ (elementWidth + padding);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            count,
            (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = index + 1;
                      //widget.controller.sets = index + 1;
                    });
                  },
                  child: SmallTextCard(
                    '${index + 1}',
                    selected: selected == index + 1,
                    width: elementWidth,
                    height: 42,
                  ),
                )),
      );
    });
  }
}
