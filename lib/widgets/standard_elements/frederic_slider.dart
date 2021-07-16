import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class FredericSlider extends StatefulWidget {
  const FredericSlider(
      {Key? key,
      required this.onChanged,
      this.min = 0,
      this.max = 10,
      this.snap = false,
      this.value = 5,
      this.indicatorText = ''})
      : super(key: key);

  final void Function(double) onChanged;
  final double min;
  final double max;
  final double value;
  final bool snap;
  final String indicatorText;

  @override
  _FredericSliderState createState() => _FredericSliderState();
}

class _FredericSliderState extends State<FredericSlider> {
  double value = 0;
  int divisions = 0;

  @override
  void initState() {
    value = widget.value;
    divisions = widget.max.toInt() - widget.min.toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          overlayShape: RoundSliderOverlayShape(overlayRadius: 11),
          thumbShape: _FredericSliderThumb(widget.min, widget.max),
          tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
        ),
        child: Slider(
            value: value,
            divisions: divisions,
            min: widget.min,
            max: widget.max,
            activeColor: kMainColor,
            inactiveColor: kMainColorLight,
            onChanged: (newVal) {
              setState(() {
                value = newVal;
              });
              widget.onChanged(newVal);
            }),
      ),
    );
  }
}

class _FredericSliderThumb extends SliderComponentShape {
  _FredericSliderThumb(this.min, this.max);
  final double min;
  final double max;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final double val = value == 0 ? 1 : (value * max);

    Paint paint = Paint()..color = kMainColor;
    Path path = Path();
    int pathScale = 10;
    path.moveTo(center.dx + 0 * pathScale, 7 + center.dy - 0.5 * pathScale);
    path.lineTo(center.dx + -1 * pathScale, 7 + center.dy + 1.5 * pathScale);
    path.lineTo(center.dx + 1 * pathScale, 7 + center.dy + 1.5 * pathScale);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, 12, Paint()..color = kMainColorLight);
    canvas.drawCircle(center, 12, Paint()..color = kMainColorLight);
    canvas.drawCircle(center, 8, paint);

    double normalWidth = 80;

    double left = center.dx - 39;
    double offset = 0;
    if (left < 0) {
      offset = -left - 10;
      left = -10;
    }
    if (left + normalWidth > parentBox.constraints.maxWidth) {
      offset = (left - parentBox.constraints.maxWidth) + 35;
      left = parentBox.constraints.maxWidth - normalWidth + 20;
    }

    double width = offset == 0 ? normalWidth : 70;
    double height = 31;
    double top = center.dy + 20;
    double right = left + width;
    double bottom = top + height;

    RRect rect = RRect.fromLTRBR(left, top, right, bottom, Radius.circular(10));
    canvas.drawRRect(rect, Paint()..color = Colors.white);
    canvas.drawRRect(
        rect,
        Paint()
          ..color = kCardBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    TextSpan text = TextSpan(
        style: TextStyle(color: Colors.black, fontSize: 16),
        text: '${val.ceil()} week${val.ceil() == 1 ? '' : 's'}');
    TextPainter textPainter = TextPainter(
        text: text, textDirection: textDirection, textAlign: TextAlign.center);
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - 28 + offset, center.dy + 26));
  }
}
