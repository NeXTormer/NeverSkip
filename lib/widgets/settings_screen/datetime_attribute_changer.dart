import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class DateTimeAttributeChanger extends StatefulWidget {
  const DateTimeAttributeChanger(
      {required this.currentValue, required this.updateValue, Key? key})
      : super(key: key);

  final DateTime? Function() currentValue;
  final void Function(DateTime?) updateValue;

  @override
  _DateTimeAttributeChangerState createState() =>
      _DateTimeAttributeChangerState();
}

class _DateTimeAttributeChangerState extends State<DateTimeAttributeChanger> {
  TextEditingController controller = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentValue = widget.currentValue() ?? DateTime.now();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: FredericCard(
          height: 160,
          child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: currentValue,
              onDateTimeChanged: (date) {
                selectedDate = date;
              }),
        ));
  }

  @override
  void dispose() {
    if (selectedDate != null) {
      widget.updateValue(selectedDate);
    }
    super.dispose();
  }
}
