import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/workout/period_slider.dart';
import 'package:intl/intl.dart';

///
/// To be used as a ModalBottomSheet. Can either create a new workout or edit
/// the metadata of an existing one
///
class EditWorkoutCard extends StatefulWidget {
  final FredericWorkout loadedWorkout;
  final bool addNewWorkout;

  EditWorkoutCard(this.loadedWorkout) : addNewWorkout = loadedWorkout == null;

  @override
  _EditWorkoutCardState createState() => _EditWorkoutCardState();
}

class _EditWorkoutCardState extends State<EditWorkoutCard> {
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();

  GlobalKey _form = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();

  double _period = 0;

  @override
  void initState() {
    _textEditingController.text = 'No date selected';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Form(
        key: _form,
        child: Column(
          children: [
            _buildWorkoutImageSection(),
            _buildTitleTextField(),
            _buildDescriptionTextBox(),
            PeriodSlider(onChanged: (value) => setState(() => _period = value)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Weeks: '),
                  Text(
                    '${_period.toInt()}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: _selectStartDate,
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Starting date: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _textEditingController.text,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  _selectStartDate() async {
    DateTime pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate;
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    maximumYear: 2021,
                    minimumYear: 2021,
                    minimumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _textEditingController.text =
            DateFormat('dd.MM.yyyy').format(_selectedDate);
      });
    }
  }

  Future<void> _saveForm() async {
    //final isValid = _form.currentState.validate();
    //if (!isValid) return;

    //_form.currentState.save();

    print(_titleTextController.text);
    widget.loadedWorkout.name = _titleTextController.text;
    widget.loadedWorkout.description = _descriptionEditingController.text;
    widget.loadedWorkout.period = 1; //_weeks.toInt();

    Navigator.of(context).pop();
  }

  _buildWorkoutImageSection() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        ClipRRect(
          //borderRadius: BorderRadius.only(
          //topLeft: const Radius.circular(25),
          //topRight: const Radius.circular(25),
          //),
          child: Image(
            image: NetworkImage(widget.loadedWorkout.image),
            height: 170,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -20,
          right: 20,
          child: InkWell(
            onTap: () {
              // TO DO
              // Upload image
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueAccent,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 19,
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildTitleTextField() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 8, bottom: 8, top: 8),
      child: Theme(
        data: ThemeData(primaryColor: Colors.blueAccent),
        child: TextFormField(
          controller: _titleTextController,
          initialValue: widget.loadedWorkout.name ?? 'werner',
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
          maxLength: 40,
          decoration: InputDecoration(
            icon: Icon(Icons.fitness_center),
            labelText: 'Title',
          ),
          onSaved: (value) {
            // TO DO
            // Set title of workout
          },
        ),
      ),
    );
  }

  _buildDescriptionTextBox() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blueAccent,
        ),
        child: TextFormField(
          controller: _descriptionEditingController
            ..text = widget.loadedWorkout.description,
          maxLines: 4,
          decoration: InputDecoration.collapsed(
            hintText: 'Description',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a description';
            } else if (value.length < 20) {
              return 'Please enter at least 20 characters';
            }
            return null;
          },
          onSaved: (value) {
            // TO DO
            // Save description to workout
          },
        ),
      ),
    );
  }

  _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.blueAccent,
            textColor: Colors.white,
            padding: EdgeInsets.all(8),
            onPressed: _saveForm,
            child: Text(
              widget.loadedWorkout != null
                  ? 'Update Workout'
                  : 'Create Workout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionEditingController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}
