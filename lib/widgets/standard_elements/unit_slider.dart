import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/main.dart';

enum Unit { Kg, Km, Count, Reps, Sets }

class UnitSlider extends StatefulWidget {
  const UnitSlider(
      {required this.controller,
      this.startingUnit = Unit.Kg,
      this.itemWidth = 0.2});

  final Unit startingUnit;
  final double itemWidth;
  final UnitSliderController controller;

  @override
  _UnitSliderState createState() => _UnitSliderState();
}

class _UnitSliderState extends State<UnitSlider> {
  PageController? controller;

  @override
  void initState() {
    controller = PageController(
      viewportFraction: widget.itemWidth,
      initialPage: widget.startingUnit.index,
      keepPage: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: -8.5,
            child: Container(
              width: 50,
              //height: double.infinity,
              child: Container(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    child: Icon(
                      Icons.play_arrow,
                      color: theme.mainColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: controller,
            physics: BouncingScrollPhysics(),
            pageSnapping: false,
            itemCount: Unit.values.length,
            itemBuilder: (context, index) =>
                _UnitSliderElement(Unit.values[index]),
            onPageChanged: (index) {
              widget.controller.value = unitToText(Unit.values[index]);
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
    );
  }
}

class _UnitSliderElement extends StatelessWidget {
  const _UnitSliderElement(this.unit);

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: Text(
          '${unitToText(unit)}',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class UnitSliderController with ChangeNotifier {
  String _value = '';

  String get value => _value;

  set value(String value) {
    _value = value;
    notifyListeners();
  }
}

String unitToText(Unit unit) {
  switch (unit) {
    case Unit.Count:
      return '#';
    case Unit.Kg:
      return 'kg';
    case Unit.Km:
      return 'km';
    case Unit.Reps:
      return 'reps';
    case Unit.Sets:
      return 'sets';
  }
}
