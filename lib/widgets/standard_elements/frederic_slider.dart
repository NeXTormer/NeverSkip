import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/number_wheel.dart';

enum SliderUnit { Weeks, Kilometers, Kilograms, None }

class FredericSlider extends StatefulWidget {
  const FredericSlider(
      {Key? key,
      required this.onChanged,
      this.min = 0,
      this.max = 10,
      this.thumbWidth,
      this.snap = false,
      this.isInteractive = false,
      this.value = 5,
      this.indicatorText = '',
      this.unit = SliderUnit.Weeks,
      this.startStateController,
      this.currentStateController,
      this.endStateController})
      : super(key: key);

  final void Function(double) onChanged;
  final double min;
  final double max;
  final double value;
  final double? thumbWidth;

  final bool snap;
  final bool isInteractive;

  final String indicatorText;
  final SliderUnit unit;

  final NumberSliderController? startStateController;
  final NumberSliderController? currentStateController;
  final NumberSliderController? endStateController;

  @override
  _FredericSliderState createState() => _FredericSliderState();
}

class _FredericSliderState extends State<FredericSlider> {
  double value = 0;
  double adaptiveMin = 0;
  double adaptiveCurrent = 0;
  double inverseAdaptiveCurrent = 0;
  double adaptiveMax = 0;

  int divisions = 0;

  bool inverse = false;

  @override
  void initState() {
    adaptiveMin = 1;
    adaptiveCurrent = widget.value;
    adaptiveMax = widget.value;
    value = widget.value;

    if (widget.startStateController != null &&
        widget.endStateController != null &&
        widget.currentStateController != null) {
      widget.startStateController!.addListener(() {
        if (mounted) {
          setState(() {
            adaptiveMin = widget.startStateController!.value.toDouble();
            if (adaptiveMax < adaptiveMin) {
              if (adaptiveCurrent.toInt() >= adaptiveMin) {
                widget.currentStateController!.value = adaptiveMin;
              }
              if (adaptiveCurrent < adaptiveMax ||
                  adaptiveCurrent > adaptiveMin) {
                widget.currentStateController!.value = adaptiveMin;
              }
            } else if (adaptiveMax > adaptiveMin) {
              if (adaptiveCurrent.toInt() <= adaptiveMin) {
                widget.currentStateController!.value = adaptiveMin;
              } else if (adaptiveCurrent > adaptiveMax ||
                  adaptiveCurrent < adaptiveMin) {
                widget.currentStateController!.value = adaptiveMax;
              }
            } else {
              widget.currentStateController!.value = adaptiveMin;
            }
          });
        }
      });
      widget.endStateController!.addListener(() {
        if (mounted) {
          setState(() {
            adaptiveMax = widget.endStateController!.value.toDouble();
            if (adaptiveMin < adaptiveMax) {
              if (adaptiveCurrent.toInt() >= adaptiveMax) {
                widget.currentStateController!.value = adaptiveMax;
              }
              if (adaptiveCurrent < adaptiveMin ||
                  adaptiveCurrent > adaptiveMax) {
                widget.currentStateController!.value = adaptiveMax;
              }
            } else if (adaptiveMin > adaptiveMax) {
              if (adaptiveCurrent.toInt() <= adaptiveMax) {
                widget.currentStateController!.value = adaptiveMax;
              } else if (adaptiveCurrent > adaptiveMin ||
                  adaptiveCurrent < adaptiveMax) {
                widget.currentStateController!.value = adaptiveMin;
              }
            } else {
              widget.currentStateController!.value = adaptiveMax;
            }
          });
        }
      });
      widget.currentStateController!.addListener(() {
        if (mounted) {
          setState(() {
            adaptiveCurrent = widget.currentStateController!.value.toDouble();
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    divisions = widget.isInteractive
        ? (adaptiveMax.toInt() - adaptiveMin.toInt()).abs()
        : (widget.max.toInt() - widget.min.toInt());
    if (adaptiveMin >= adaptiveMax) {
      inverse = true;
      inverseAdaptiveCurrent = inverseValue(
          adaptiveCurrent, adaptiveMax, adaptiveMin,
          normalized: false);
    } else
      inverse = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          overlayShape: RoundSliderOverlayShape(overlayRadius: 11),
          thumbShape: _FredericSliderThumb(
              widget.isInteractive ? adaptiveMin : widget.min,
              widget.isInteractive ? adaptiveMax : widget.max,
              widget.isInteractive ? adaptiveCurrent : value,
              widget.unit,
              thumbWidth: widget.thumbWidth,
              inverse: (adaptiveMin <= adaptiveMax) ? false : true),
          tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
        ),
        child: Slider(
            value: widget.isInteractive
                ? (inverse ? inverseAdaptiveCurrent : adaptiveCurrent)
                : value,
            divisions: divisions <= 0 ? 1 : divisions,
            min: widget.isInteractive
                ? (adaptiveMin >= adaptiveMax ? adaptiveMax : adaptiveMin)
                : widget.min,
            max: widget.isInteractive
                ? (adaptiveMax <= adaptiveMin ? adaptiveMin : adaptiveMax)
                : widget.max,
            activeColor: theme.mainColor,
            inactiveColor: theme.mainColorLight,
            onChanged: (newVal) {
              setState(() {
                if (widget.currentStateController != null) {
                  if (inverse) {
                    widget.currentStateController!.value = inverseValue(
                        newVal, adaptiveMax, adaptiveMin,
                        normalized: false);
                  } else
                    widget.currentStateController!.value = newVal;
                } else {
                  value = newVal;
                }
              });
              widget.onChanged(newVal);
            }),
      ),
    );
  }

  double inverseValue(double value, double start, double end,
      {bool normalized = true}) {
    if ((end - start) == 0) return start;
    double startEndDifference = (end - start).abs();
    double inverseTrueCurrentValue =
        start + startEndDifference * (1 - normalizeValue(value, start, end));

    if (normalized)
      return normalizeValue(inverseTrueCurrentValue, start, end);
    else
      return inverseTrueCurrentValue;
  }

  double normalizeValue(num value, num start, num end) {
    if ((end - start) == 0) return 1;
    return (value - start) / (end - start);
  }
}

class _FredericSliderThumb extends SliderComponentShape {
  _FredericSliderThumb(this.min, this.max, this.labelValue, this.unit,
      {this.inverse = false, this.thumbWidth}) {
    if (thumbWidth == null) thumbWidth = 80;
  }
  final double min;
  final double max;
  double? thumbWidth;
  final double labelValue;
  final SliderUnit unit;
  final bool inverse;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(1);
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
    final double val = (min + (value) * (max - min));

    Paint paint = Paint()..color = theme.mainColor;
    Path path = Path();
    int pathScale = 10;
    path.moveTo(center.dx + 0 * pathScale, 7 + center.dy - 0.5 * pathScale);
    path.lineTo(center.dx + -1 * pathScale, 7 + center.dy + 1.5 * pathScale);
    path.lineTo(center.dx + 1 * pathScale, 7 + center.dy + 1.5 * pathScale);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, 12, Paint()..color = theme.mainColorLight);
    canvas.drawCircle(center, 12, Paint()..color = theme.mainColorLight);
    canvas.drawCircle(center, 8, paint);

    double normalWidth = getThumbWidth(unit);

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

    if (offset < -20) offset = 0;

    double width = offset == 0 ? normalWidth : normalWidth - 10;
    double height = 31;
    double top = center.dy + 20;
    double right = left + width;
    double bottom = top + height;

    RRect rect = RRect.fromLTRBR(left, top, right, bottom, Radius.circular(10));
    canvas.drawRRect(rect, Paint()..color = theme.backgroundColor);
    canvas.drawRRect(
        rect,
        Paint()
          ..color = theme.textColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    TextSpan text = TextSpan(
        style: TextStyle(color: theme.textColor, fontSize: 16),
        text: '${getLabelUnit(unit, val.toInt())}');
    TextPainter textPainter =
        TextPainter(text: text, textDirection: textDirection);
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - 28 + offset, center.dy + 26));
  }

  String getLabelUnit(SliderUnit unit, int value) {
    switch (unit) {
      case SliderUnit.Weeks:
        if (value == 1) return '$value ' + loc.tr('misc.week');
        return '$value ' + loc.tr('misc.weeks');
      case SliderUnit.Kilograms:
        return '${labelValue.ceil()} kg';
      case SliderUnit.Kilometers:
        return '$value km';
      default:
        return '$value';
    }
  }

  double getThumbWidth(SliderUnit unit) {
    switch (unit) {
      case SliderUnit.Weeks:
        return 80;
      case SliderUnit.Kilograms:
        return 60;
      case SliderUnit.Kilometers:
        return 60;
      default:
        return 80;
    }
  }
}
