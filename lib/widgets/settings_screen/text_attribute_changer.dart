import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';

class TextAttributeChanger extends StatefulWidget {
  const TextAttributeChanger(
      {required this.currentValue,
      required this.updateValue,
      required this.placeholder,
      Key? key})
      : super(key: key);

  final String placeholder;
  final String Function() currentValue;
  final void Function(String) updateValue;

  @override
  _TextAttributeChangerState createState() => _TextAttributeChangerState();
}

class _TextAttributeChangerState extends State<TextAttributeChanger> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentValue = widget.currentValue();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FredericTextField(
          widget.placeholder,
          brightContents: theme.isDark,
          controller: controller,
          text: currentValue,
          onSubmit: (value) {
            widget.updateValue(value);
          },
          icon: null,
        ));
  }
}
