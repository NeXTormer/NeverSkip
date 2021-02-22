import 'package:flutter/material.dart';

class WorkoutPrompt extends StatefulWidget {
  WorkoutPrompt(this.initialWeek);

  final double initialWeek;

  @override
  _WorkoutPromptState createState() => _WorkoutPromptState();
}

class _WorkoutPromptState extends State<WorkoutPrompt> {
  double _weeks = 1;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    _weeks = widget.initialWeek;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _weeks = 1;
    return AlertDialog(
      title: Text('Create New Workout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Weeks: ${_weeks.round()}'),
          Container(
            child: Slider.adaptive(
              value: _weeks,
              min: 1,
              max: 28,
              divisions: 27,
              onChanged: (value) {
                setState(() {
                  _weeks = value;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Create'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
