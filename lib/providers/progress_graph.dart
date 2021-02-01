import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frederic/providers/goals.dart';

class ProgressGraphItem {
  final String id;
  final String title;
  List<List<double>> lines;
  List<Legend> legend;
  final String label;

  ProgressGraphItem({
    @required this.id,
    @required this.title,
    @required this.lines,
    @required this.legend,
    @required this.label,
  });
}

class Legend {
  String title;
  final Color color;

  Legend(this.title, this.color);
}

class ProgressGraph with ChangeNotifier {
  var _graphs = [
    ProgressGraphItem(
      id: 'gr1',
      title: 'Reputations',
      lines: [
        [1, 2, 2, 3, 4, 5],
        [2, 3, 3, 3, 5, 4],
      ],
      legend: [
        Legend('Push Ups', Colors.blue),
        Legend('Pull Ups', Colors.green),
      ],
      label: 'reps',
    )
  ];

  List<ProgressGraphItem> get graphs {
    return [..._graphs];
  }

  ProgressGraphItem getGraphWithId(String id) {
    return _graphs.firstWhere((graph) => graph.id == id);
  }

  int getGraphCount() {
    return _graphs.length;
  }

  void addProgressGraph(ProgressGraphItem graph) {
    // Logic for when the label already exists
    List<ProgressGraphItem> _graphList = graphs;
    ProgressGraphItem _matchedGrah;
    try {
      _matchedGrah =
          _graphList.firstWhere((graphItem) => graphItem.label == graph.label);
    } catch (error) {
      _graphs.add(graph);
      notifyListeners();
      return;
    }
    _matchedGrah.legend.add(graph.legend[0]);
    _matchedGrah.lines.add(graph.lines[0]);
    notifyListeners();
  }

  void addLineValue(String id, int lineIndex, double value) {
    List<double> line = getGraphWithId(id).lines[lineIndex];
    line.add(value);
    notifyListeners();
  }

  void addLine(String id, List<double> spots) {
    ProgressGraphItem graph = getGraphWithId(id);
    graph.lines.add(spots);
    notifyListeners();
  }
}
