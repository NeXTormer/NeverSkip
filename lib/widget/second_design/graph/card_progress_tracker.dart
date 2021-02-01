import 'package:flutter/material.dart';
import 'package:frederic/providers/progress_graph.dart';

import 'package:frederic/widget/second_design/graph/chart_item.dart';

/// Displays title and the legend items of the corresponding [ProgressGraphItem], which is taken as constructor argument.
///
/// First staticly displays title.
/// Then iterates through the [graph]'s [Legend] items and displays them as container and title next to eacht other.
/// Lastly calls the [CardChartItem] to desplay the actual chart.
class CardProgressTracker extends StatelessWidget {
  final ProgressGraphItem graph;

  CardProgressTracker(this.graph);

  /// Outsources the legend of the the graph.
  ///
  /// Takes [title] as legends title and [colors] as the color of the colored square.
  /// Return colored square container and title next to each other.
  Widget buildlegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(title),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  graph.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...graph.legend.map(
                      (legend) {
                        return buildlegendItem(legend.title, legend.color);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          CardChartItem(graph),
        ],
      ),
    );
  }
}
