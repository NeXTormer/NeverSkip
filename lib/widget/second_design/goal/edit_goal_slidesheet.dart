import 'package:flutter/material.dart';
import 'package:frederic/providers/goals.dart';
import 'package:provider/provider.dart';

class EditGoalSlidesheet extends StatefulWidget {
  final String goalId;

  EditGoalSlidesheet(this.goalId);

  @override
  _EditGoalSlidesheetState createState() => _EditGoalSlidesheetState();
}

class _EditGoalSlidesheetState extends State<EditGoalSlidesheet> {
  final _formKey = GlobalKey<FormState>();
  List<Item> users = <Item>[
    const Item(
        'Weight',
        Icon(
          Icons.android,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'Reputations',
        Icon(
          Icons.flag,
          color: const Color(0xFF167F67),
        )),
  ];

  var _editedGoalItem = GoalItem(
    id: null,
    title: '',
    current: 0.0,
    target: 0.0,
    interval: 0,
    type: GoalType.Reputations,
    imageUrl:
        'https://www.holdstrong.de/magazin/wp-content/uploads/2019/06/butterfly-kipping-pull-up-750x500.jpg',
  );

  var _initValues = {
    'title': '',
    'dueDate': '',
    'start': 0.0,
    'target': 0.0,
  };

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.goalId != null) {
        _editedGoalItem =
            Provider.of<Goals>(context, listen: false).findById(widget.goalId);
        _initValues = {
          'title': _editedGoalItem.title,
          'start': _editedGoalItem.current,
          'target': _editedGoalItem.target,
          'dueDate': _editedGoalItem.interval,
          'type': _editedGoalItem.type,
          'imageUrl': _editedGoalItem.imageUrl,
        };
      }
    }
    super.didChangeDependencies();
  }

  void _saveForm() {
    _formKey.currentState.save();
    if (widget.goalId != null) {
      Provider.of<Goals>(context, listen: false)
          .updateGoal(widget.goalId, _editedGoalItem);
    } else {
      Provider.of<Goals>(context, listen: false).addGoal(_editedGoalItem);
    }
    Navigator.of(context).pop();
  }

  String dropdownValue = 'Weighted';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField(
              items: <String>['Weighted', 'Reputations']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(
                  () {
                    //_selectedValue = value;
                    // TO DO - Better Item implementation
                    dropdownValue = value;
                  },
                );
              },
              hint: Text('Select Type'),
              onSaved: (input) {
                _editedGoalItem = GoalItem(
                  id: _editedGoalItem.id,
                  title: _editedGoalItem.title,
                  current: _editedGoalItem.current,
                  target: _editedGoalItem.target,
                  interval: _editedGoalItem.interval,
                  type: dropdownValue == 'Weighted'
                      ? GoalType.Weighted
                      : GoalType.Reputations,
                  imageUrl: _editedGoalItem.imageUrl,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(labelText: 'Title'),
                    onSaved: (input) {
                      _editedGoalItem = GoalItem(
                        id: _editedGoalItem.id,
                        title: input,
                        current: _editedGoalItem.current,
                        target: _editedGoalItem.target,
                        interval: _editedGoalItem.interval,
                        type: _editedGoalItem.type,
                        imageUrl: _editedGoalItem.imageUrl,
                      );
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: _initValues['dueDate'].toString(),
                    decoration: InputDecoration(labelText: 'Due Date'),
                    onSaved: (input) {
                      _editedGoalItem = GoalItem(
                        id: _editedGoalItem.id,
                        title: _editedGoalItem.title,
                        current: _editedGoalItem.current,
                        target: _editedGoalItem.target,
                        interval: int.parse(input),
                        type: _editedGoalItem.type,
                        imageUrl: _editedGoalItem.imageUrl,
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: _initValues['start'].toString(),
                    decoration: InputDecoration(labelText: 'Start'),
                    onSaved: (input) {
                      _editedGoalItem = GoalItem(
                        id: _editedGoalItem.id,
                        title: _editedGoalItem.title,
                        current: double.parse(input),
                        target: _editedGoalItem.target,
                        interval: _editedGoalItem.interval,
                        type: _editedGoalItem.type,
                        imageUrl: _editedGoalItem.imageUrl,
                      );
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    enabled: false,
                    initialValue: '',
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: _initValues['target'].toString(),
                    onSaved: (input) {
                      _editedGoalItem = GoalItem(
                        id: _editedGoalItem.id,
                        title: _editedGoalItem.title,
                        current: _editedGoalItem.current,
                        target: double.parse(input),
                        interval: _editedGoalItem.interval,
                        type: _editedGoalItem.type,
                        imageUrl: _editedGoalItem.imageUrl,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveForm();
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final Icon icon;
  const Item(this.name, this.icon);
}
