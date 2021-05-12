import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/workout_list_screen/period_slider.dart';
import 'package:intl/intl.dart';

///
/// To be used as a ModalBottomSheet. Can either create a new workout or edit
/// the metadata of an existing one
///
class EditWorkoutPage extends StatefulWidget {
  final FredericWorkout? loadedWorkout;
  final bool addNewWorkout;

  EditWorkoutPage([this.loadedWorkout]) : addNewWorkout = loadedWorkout == null;

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();

  GlobalKey _form = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();

  double _period = 1;
  bool _repeating = true;
  late String _dateText;

  @override
  void initState() {
    super.initState();
    _descriptionEditingController.text =
        widget.loadedWorkout?.description ?? '';
    _titleTextController.text = widget.loadedWorkout?.name ?? '';
    _period = widget.loadedWorkout?.period?.toDouble() ?? 1;
    _repeating = widget.loadedWorkout?.repeating ?? true;
    _dateText = DateFormat('dd.MM.yyyy').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
              )),
          child: Form(
            key: _form,
            child: Column(
              children: [
                _buildWorkoutImageSection(),
                _buildTitleTextField(),
                _buildDescriptionTextBox(),
                PeriodSlider(
                    onChanged: (value) => setState(() => _period = value),
                    startValue: _period),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text('Weeks: '),
                      Text(
                        '${_period.toInt()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Repeating'),
                      Switch.adaptive(
                        activeColor: kMainColor,
                        value: _repeating,
                        onChanged: (bool value) {
                          setState(() {
                            _repeating = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Starting week'),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black38),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: _selectStartDate,
                          child: Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 5),
                              Text(
                                _dateText,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.loadedWorkout?.canEdit ?? false)
                      _buildDeleteButton()
                    else
                      Container(),
                    _buildSubmitButton(),
                  ],
                ),
                SizedBox(height: 6)
              ],
            ),
          ),
        ),
      ],
    );
  }

  _selectStartDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime? tempPickedDate;
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
                    maximumYear: DateTime.now().year + 1,
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
        _dateText = DateFormat('dd.MM.yyyy').format(_selectedDate);
      });
    }
  }

  Future<void> _saveForm() async {
    if (widget.addNewWorkout) {
      FredericWorkout.create(
          title: _titleTextController.text,
          description: _descriptionEditingController.text,
          image: null,
          period: _period.toInt(),
          repeating: false,
          startDate: DateTime.now());
    } else {
      widget.loadedWorkout!.name = _titleTextController.text;
      widget.loadedWorkout!.description = _descriptionEditingController.text;
      widget.loadedWorkout!.period = _period.toInt();
    }
    Navigator.of(context).pop();
  }

  _buildWorkoutImageSection() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
          ),
          child: Image(
            image: CachedNetworkImageProvider(widget.loadedWorkout?.image ??
                'https://miro.medium.com/max/14144/1*toyr_4D7HNbvnynMj5XjXw.jpeg'),
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
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8, top: 8),
      child: Theme(
        data: ThemeData(primaryColor: kMainColor),
        child: TextFormField(
          controller: _titleTextController,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'Title',
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Please enter a title';
            return null;
          },
          maxLength: 42,
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
          primaryColor: kMainColor,
        ),
        child: TextFormField(
          controller: _descriptionEditingController,
          maxLines: 4,
          maxLength: 220,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration.collapsed(
            hintText: 'Description',
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Please enter a description';
            return null;
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
              borderRadius: BorderRadius.circular(8),
            ),
            color: kMainColor,
            textColor: Colors.white,
            padding: EdgeInsets.all(8),
            onPressed: _saveForm,
            child: Text(
              widget.loadedWorkout != null
                  ? 'Update Workout'
                  : 'Create Workout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.red,
            textColor: Colors.white,
            padding: EdgeInsets.all(8),
            onPressed: showDeleteDialog,
            child: Text(
              widget.loadedWorkout?.canEdit ?? false ? 'Delete' : '',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete workout'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 8),
                Text(
                  'Do you want to delete the workout "${widget.loadedWorkout!.name}"?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text('This action can not be undone!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Delete',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                widget.loadedWorkout!.delete();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }
}
