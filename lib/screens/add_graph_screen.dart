import 'package:flutter/material.dart';
import 'package:frederic/providers/progress_graph.dart';
import 'package:provider/provider.dart';

class AddGraphScreen extends StatefulWidget {
  static var routeName = '/Add-Graph';

  @override
  _AddGraphScreenState createState() => _AddGraphScreenState();
}

class _AddGraphScreenState extends State<AddGraphScreen> {
  var _formKey = GlobalKey<FormState>();
  int _index = 0;

  var _initValues = {
    'type': '',
    'title': '',
    'activity': '',
    'label': '',
  };

  var _editedGraph = ProgressGraphItem(
    id: null,
    title: '',
    lines: [[]],
    legend: [],
    label: '',
  );

  var _newLegend = Legend(
    '',
    null,
  );

  List _colors = [Colors.blue, Colors.blueAccent, Colors.cyanAccent];

  void changeIndex() {
    setState(() => _index++);
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    _editedGraph.legend.add(_newLegend);
    Provider.of<ProgressGraph>(context, listen: false)
        .addProgressGraph(_editedGraph);
    //Provider.of<ProgressGraph>(context).addLine(DateTime.now().toIso8601String(), spots)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text('Add Graph'),
          leading: Icon(Icons.add_alert),
          actions: [
            IconButton(icon: Icon(Icons.list), onPressed: () {}),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                // TODO -  Update
                decoration: InputDecoration(labelText: 'Tracking Type'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editedGraph = ProgressGraphItem(
                          id: null,
                          title: value,
                          lines: _editedGraph.lines,
                          legend: _editedGraph.legend,
                          label: _editedGraph.label,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Text('/'),
                  SizedBox(width: 20),
                  Container(
                    width: 100,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Activity'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _newLegend = Legend(
                          value,
                          _colors[_index],
                        );
                        _editedGraph.legend.add(_newLegend);
                        changeIndex();
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Label'),
                textInputAction: TextInputAction.done,
                onSaved: (value) {
                  _editedGraph = ProgressGraphItem(
                    id: null,
                    title: _editedGraph.title,
                    lines: _editedGraph.lines,
                    legend: _editedGraph.legend,
                    label: value,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Starting Value'),
                textInputAction: TextInputAction.done,
                onSaved: (value) {
                  _editedGraph.lines[0].add(double.parse(value));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _saveForm();
                      // Navigator.of(context).pop();
                    },
                    child: Text('Add to graph'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
