import 'package:flutter/material.dart';
import 'package:frederic/providers/goals.dart';
import 'package:provider/provider.dart';

class EditGoalItem extends StatefulWidget {
  final goalId;
  EditGoalItem(this.goalId);

  @override
  _EditGoalItemState createState() => _EditGoalItemState();
}

class _EditGoalItemState extends State<EditGoalItem> {
  final _formKey = GlobalKey<FormState>();

  var _editedGoalItem = GoalItem(
    id: null,
    title: '',
    current: 0.0,
    target: 0.0,
    interval: 0,
    type: GoalType.Repetitions,
    imageUrl:
        'https://www.muscleandfitness.com/wp-content/uploads/2019/02/man-bench-press.jpg?quality=86&strip=all',
  );

  var _initValues = {
    'title': '',
    'current': 0.0,
    'target': 0.0,
    'interval': 0,
    'type': GoalType.Repetitions,
    'imageUrl': ''
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
          'current': _editedGoalItem.current,
          'target': _editedGoalItem.target,
          'interval': _editedGoalItem.interval,
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
      // TO DO
      // update goal
    } else {
      Provider.of<Goals>(context, listen: false).addGoal(_editedGoalItem);
      print(Provider.of<Goals>(context, listen: false).itemCount);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              height: 300,
              width: 300,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a title.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedGoalItem = GoalItem(
                          id: _editedGoalItem.id,
                          title: value,
                          current: _editedGoalItem.current,
                          target: _editedGoalItem.target,
                          interval: _editedGoalItem.interval,
                          type: _editedGoalItem.type,
                          imageUrl: _editedGoalItem.imageUrl);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['current'].toString(),
                    decoration: InputDecoration(labelText: 'Current'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a your start condition.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedGoalItem = GoalItem(
                          id: _editedGoalItem.id,
                          title: _editedGoalItem.title,
                          current: double.parse(value),
                          target: _editedGoalItem.target,
                          interval: _editedGoalItem.interval,
                          type: _editedGoalItem.type,
                          imageUrl: _editedGoalItem.imageUrl);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['target'].toString(),
                    decoration: InputDecoration(labelText: 'Target'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a your target condition.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedGoalItem = GoalItem(
                          id: _editedGoalItem.id,
                          title: _editedGoalItem.title,
                          current: _editedGoalItem.current,
                          target: double.parse(value),
                          interval: _editedGoalItem.interval,
                          type: _editedGoalItem.type,
                          imageUrl: _editedGoalItem.imageUrl);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['interval'].toString(),
                    decoration: InputDecoration(labelText: 'Interval'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a your target interval.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedGoalItem = GoalItem(
                          id: _editedGoalItem.id,
                          title: _editedGoalItem.title,
                          current: _editedGoalItem.current,
                          target: _editedGoalItem.target,
                          interval: int.parse(value),
                          type: _editedGoalItem.type,
                          imageUrl: _editedGoalItem.imageUrl);
                    },
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
