import 'package:flutter/material.dart';
import 'package:frederic/providers/progress_graph.dart';
import 'package:frederic/widget/second_design/graph/card_progress_tracker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

/// Displays the user's saved graphs.
///
/// Iterates through [List<ProgressGraphItem> _progressGrahs] and genrates a corresponding [CardProgressTracker] (Graph).
class ProgressPage extends StatefulWidget {
  @override
  _ProgressPage createState() => _ProgressPage();
}

class _ProgressPage extends State<ProgressPage> {
  final controller = PageController(viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    final _progressGraphData = Provider.of<ProgressGraph>(context);
    final _progressGraphs = _progressGraphData.graphs;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 240,
            child: PageView(
              controller: controller,
              children: List.generate(
                _progressGraphData.getGraphCount(),
                (index) => CardProgressTracker(_progressGraphs[index]),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            child: SmoothPageIndicator(
              controller: controller,
              count: _progressGraphData.getGraphCount(),
              effect: SlideEffect(
                spacing: 15.0,
                radius: 4.0,
                dotWidth: 70.0,
                dotHeight: 5.0,
                paintStyle: PaintingStyle.fill,
                activeDotColor: Colors.blue,
                dotColor: Colors.grey[300],
                strokeWidth: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
