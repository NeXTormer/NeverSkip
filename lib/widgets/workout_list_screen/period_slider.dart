import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class PeriodSlider extends StatefulWidget {
  PeriodSlider(
      {this.startValue = 1,
      this.min = 1,
      this.max = 10,
      @required this.onChanged});
  final double startValue;
  final double min;
  final double max;

  final Function(double) onChanged;

  @override
  _PeriodSliderState createState() => _PeriodSliderState();
}

class _PeriodSliderState extends State<PeriodSlider> {
  double value;

  @override
  void initState() {
    value = widget.startValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slider.adaptive(
        onChanged: (value) {
          widget.onChanged(value);
          setState(() {
            this.value = value;
          });
        },
        activeColor: kMainColor,
        value: value,
        min: widget.min,
        max: widget.max,
        divisions: (widget.max - widget.min).toInt(),
      ),
    );
  }
}
