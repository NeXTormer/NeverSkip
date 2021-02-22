import 'package:flutter/material.dart';

class WorkoutPrompt extends StatefulWidget {
  @override
  _WorkoutPromptState createState() => _WorkoutPromptState();
}

class _WorkoutPromptState extends State<WorkoutPrompt> {
  double _weeks = 1;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Workout'),
      content: Container(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Theme(
              data: ThemeData(
                primaryColor: Colors.orangeAccent,
              ),
              child: TextFormField(
                initialValue: 'Title',
                maxLength: 30,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.fitness_center,
                  ),
                  labelText: 'Title',
                  suffixIcon: Icon(
                    Icons.check_circle,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent[100]),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 8,
                  decoration:
                      InputDecoration.collapsed(hintText: 'Description'),
                ),
              ),
            ),
            Divider(),
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
            Row(
              children: [
                Text('Weeks: '),
                Text(
                  '${_weeks.round()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
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
