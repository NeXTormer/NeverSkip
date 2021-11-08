import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_divider.dart';

class FredericMultipleChoiceElement {
  FredericMultipleChoiceElement(this.index, this.text, this.icon,
      {this.info, this.selected});

  String text;
  IconData icon;
  int index;

  bool? selected;

  String? info;
}

class FredericMultipleChoiceController {
  FredericMultipleChoiceController()
      : selectedElements = <FredericMultipleChoiceElement>[];

  List<FredericMultipleChoiceElement> selectedElements;
}

class FredericMultipleChoice extends StatefulWidget {
  const FredericMultipleChoice(this.elements,
      {required this.controller, Key? key})
      : super(key: key);

  final List<FredericMultipleChoiceElement> elements;
  final FredericMultipleChoiceController controller;

  @override
  _FredericMultipleChoiceState createState() => _FredericMultipleChoiceState();
}

class _FredericMultipleChoiceState extends State<FredericMultipleChoice> {
  List<FredericMultipleChoiceElement>? elements;

  @override
  void initState() {
    elements = widget.elements;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        child: Column(
            children: List.generate(
                (elements!.length * 2) - 1,
                (index) => (index % 2 == 1 &&
                        (index != 0 && index != (elements!.length * 2) - 1))
                    ? FredericDivider()
                    : GestureDetector(
                        onTap: () {
                          int i = index ~/ 2;
                          setState(() {
                            elements![i].selected =
                                !(elements![i].selected ?? false);
                            widget.controller.selectedElements = elements!
                                .where((element) => element.selected ?? false)
                                .toList();
                          });
                        },
                        child: _FredericMulipleChoiceElementWidget(
                            elements![index ~/ 2]),
                      ))));
  }
}

class _FredericMulipleChoiceElementWidget extends StatelessWidget {
  const _FredericMulipleChoiceElementWidget(this.data, {Key? key})
      : super(key: key);

  final FredericMultipleChoiceElement data;

  @override
  Widget build(BuildContext context) {
    bool selected = data.selected ?? false;

    return Container(
      decoration: BoxDecoration(
          color: theme.cardBackgroundColor,
          borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      height: 42,
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_outlined,
            color: theme.mainColor,
          ),
          SizedBox(width: 8),
          Text(data.text),
          Expanded(child: Container()),
          Icon(
            data.icon,
            color: theme.greyColor,
          ),
        ],
      ),
    );
  }
}
