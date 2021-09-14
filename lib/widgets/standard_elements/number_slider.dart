import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/main.dart';

///
/// Creates a number slider with [numberOfItems] entries. Needs a
/// [NumberSliderController] to get the selected Value.
/// [width], [height], and [itemWidth] can be customized. The [itemWidth] means
/// the percentage of the screen width which one item takes up.
///
class NumberSlider extends StatefulWidget {
  NumberSlider({
    required this.controller,
    this.numberOfItems = 400,
    this.startingIndex = 10,
    this.itemWidth = 0.2,
  });

  final int startingIndex;
  final int numberOfItems;
  final double itemWidth;
  final NumberSliderController controller;

  @override
  _NumberSliderState createState() => _NumberSliderState();
}

class _NumberSliderState extends State<NumberSlider> {
  PageController? controller;

  @override
  void initState() {
    controller = PageController(
        viewportFraction: widget.itemWidth,
        initialPage: widget.startingIndex,
        keepPage: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int start = widget.startingIndex - 2;
    if (start < 0) start = 0;
    Future.delayed(Duration.zero)
        .then((value) => controller!.jumpToPage(start));
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
                child: Container(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Container(
                      child: Icon(
                        Icons.play_arrow,
                        color: kMainColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            PageView.builder(
              itemBuilder: (context, index) => _NumberSliderElement(index + 1),
              itemCount: widget.numberOfItems,
              physics: BouncingScrollPhysics(),
              pageSnapping: false,
              onPageChanged: (index) {
                widget.controller.value = index + 1;
                HapticFeedback.lightImpact();
              },
              controller: controller,
            ),
          ],
        ));
  }
}

class _NumberSliderElement extends StatelessWidget {
  _NumberSliderElement(this.number);

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class NumberSliderController with ChangeNotifier {
  num _value = 0;

  num get value => _value;

  set value(num value) {
    _value = value;
    notifyListeners();
  }
}
