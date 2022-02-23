import 'package:flutter/material.dart';

import '../standard_elements/frederic_card.dart';
import '../standard_elements/frederic_heading.dart';

class FredericChart extends StatefulWidget {
  const FredericChart(
      {required this.title,
      required this.pages,
      this.reversed = true,
      this.height = 216,
      this.padding,
      Key? key})
      : super(key: key);

  final List<FredericChartPage> pages;
  final String title;
  final bool reversed;
  final double height;
  final EdgeInsets? padding;

  @override
  _FredericChartState createState() => _FredericChartState();
}

class _FredericChartState extends State<FredericChart> {
  PageController pageController = PageController();
  String? subtitle;

  int lastPage = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(handlePageChange);
    if (widget.pages.isEmpty) {
      subtitle = 'No Pages';
    } else {
      subtitle = widget.pages.first.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
          child: FredericHeading(widget.title, subHeading: subtitle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FredericCard(
              padding: widget.padding,
              height: widget.height,
              child: PageView(
                reverse: widget.reversed,
                physics: widget.pages.length == 1
                    ? const ClampingScrollPhysics()
                    : const BouncingScrollPhysics(),
                controller: pageController,
                children: [for (final page in widget.pages) page.page],
              )),
        )
      ],
    );
  }

  void handlePageChange() {
    int currentPage = pageController.page?.round() ?? 0;
    if (currentPage == lastPage) return;
    lastPage = currentPage;
    setState(() {
      subtitle = widget.pages[currentPage].title;
    });
  }

  @override
  void dispose() {
    pageController.removeListener(handlePageChange);
    super.dispose();
  }
}

class FredericChartPage {
  FredericChartPage({this.title, required this.page});

  final Widget page;
  final String? title;
}
