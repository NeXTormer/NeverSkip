import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:intl/intl.dart';

class EditGoalView extends StatefulWidget {
  EditGoalView({this.goal});
  final FredericGoal goal;

  @override
  _EditGoalViewState createState() => _EditGoalViewState();
}

class _EditGoalViewState extends State<EditGoalView> {
  final _form = GlobalKey<FormState>();

  var initValues = {
    'title': '',
    'start': '',
    'current': '',
    'end': '',
    'duration': 1,
  };
  String _title = '';
  String _image = 'https://kknd26.ru/images/no_photo.png';
  DateTime _startDate = DateTime.now();
  num _start = 0;
  num _current = 0;
  num _end = 0;
  double _weeks = 1;

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _image = widget.goal.image;
      _title = widget.goal.title;
      _startDate = widget.goal.startDate;
      _start = widget.goal.startState;
      _current = widget.goal.currentState;
      _end = widget.goal.endState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _buildImageSection(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(
                          primaryColor: Colors.lightBlue,
                        ),
                        child: TextFormField(
                          maxLength: 30,
                          initialValue: _title,
                          decoration: InputDecoration(
                            hintText: 'e.g. Bench Press',
                            icon: Icon(Icons.fitness_center),
                            labelText: 'title',
                            suffix: Icon(Icons.check_circle),
                          ),
                        ),
                      ),
                      Text(
                        'Started: ${DateFormat('dd.MM.yyyy').format(_startDate)}',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      Divider(thickness: 0.8),
                      _buildDataSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildDialogButton(
                  'Cancel',
                  Colors.redAccent,
                  () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 10),
                _buildDialogButton(
                  'Create',
                  Colors.lightBlue,
                  () {
                    // TODO
                    // Create new goal
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildDialogButton(String text, Color color, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _buildImageSection() {
    return InkWell(
      onTap: () {
        // TODO
        // Open Image Picker
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Image.network(
          _image,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildDataSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDataColText('$_start', 'Start'),
              _buildVerticalDivider(color: Colors.black26),
              _buildDataColText('$_current', 'Current'),
              _buildVerticalDivider(color: Colors.black26),
              _buildDataColText('$_end', 'Target'),
            ],
          ),
          _buildSlider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.timer, size: 20),
              SizedBox(width: 5),
              Text('Duration: '),
              Text(
                '${_weeks.round().toString()} Weeks',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildDataColText(String data, String title) {
    return Column(
      children: [
        Text(
          data,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  _buildVerticalDivider({double width = 0.5, Color color = Colors.black45}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: width,
            color: color,
          ),
        ),
      ),
    );
  }

  _buildSlider() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Slider.adaptive(
        onChanged: (value) {
          setState(() {
            _weeks = value;
          });
        },
        activeColor: Colors.lightBlue,
        value: _weeks,
        min: 1,
        max: 28,
        divisions: 27,
      ),
    );
  }
}
