import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:intl/intl.dart';

class AddWorkoutCard extends StatefulWidget {
  final FredericWorkout loadedWorkout;

  AddWorkoutCard(this.loadedWorkout);

  @override
  _AddWorkoutCardState createState() => _AddWorkoutCardState();
}

class _AddWorkoutCardState extends State<AddWorkoutCard> {
  final _titleTextController = TextEditingController();
  final _decriptionEditingController = TextEditingController();
  final _editedWorkout = FredericWorkout('');
  final _form = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  bool _isInit = true;
  bool _isLoading = false;

  double _weeks = 1;

  DateTime _selectedDate = DateTime.now();

  var _initialValues = {
    'imageUrl':
        'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
    'title': '',
    'description': '',
    'weeks': 1,
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _textEditingController.text = 'No date selected';
      if (widget.loadedWorkout != null) {
        _initialValues = {
          'imageUrl': widget.loadedWorkout.image,
          'title': widget.loadedWorkout.name,
          'description': widget.loadedWorkout.description,
          'weeks': widget.loadedWorkout.period,
        };
        int temp = _initialValues['weeks'];
        _weeks = temp.toDouble();
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(25),
          topRight: const Radius.circular(25),
        ),
      ),
      child: Form(
        key: _form,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  _buildWorkoutImageSection(),
                  _buildTitleTextField(),
                  _buildDescriptionTextBox(),
                  _buildSlider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text('Weeks: '),
                        Text(
                          '${_weeks.round()}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
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
    final isValid = _form.currentState.validate();
    if (!isValid) return;

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedWorkout.workoutID != null) {
      print(_titleTextController.text);
      widget.loadedWorkout.name = _titleTextController.text;
      widget.loadedWorkout.description = _decriptionEditingController.text;
      widget.loadedWorkout.period = _weeks.toInt();
    } else {
      print('nono noono');
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  _buildWorkoutImageSection() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25),
            topRight: const Radius.circular(25),
          ),
          child: Image(
            image: NetworkImage(_initialValues['imageUrl']),
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
              backgroundColor: Colors.orangeAccent,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 19,
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.orangeAccent,
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
        data: ThemeData(primaryColor: Colors.orangeAccent),
        child: TextFormField(
          controller: _titleTextController..text = _initialValues['title'],
          // initialValue: _initialValues['title'],
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
          primaryColor: Colors.orangeAccent,
        ),
        child: TextFormField(
          controller: _decriptionEditingController
            ..text = _initialValues['description'],
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
            color: Colors.orangeAccent,
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
    _decriptionEditingController.dispose();
    super.dispose();
  }
}
