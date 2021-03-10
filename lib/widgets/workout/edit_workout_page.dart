import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/workout/period_slider.dart';
import 'package:intl/intl.dart';

///
/// To be used as a ModalBottomSheet. Can either create a new workout or edit
/// the metadata of an existing one
///
class EditWorkoutPage extends StatefulWidget {
  final FredericWorkout loadedWorkout;
  final bool addNewWorkout;

  EditWorkoutPage(this.loadedWorkout) : addNewWorkout = loadedWorkout == null;

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();

  GlobalKey _form = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();

  double _period = 1;

  @override
  void initState() {
    super.initState();
    _descriptionEditingController.text = widget.loadedWorkout?.description;
    _titleTextController.text = widget.loadedWorkout?.name;
    _period = widget.loadedWorkout.period.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                ],
              ),
            ),
            SizedBox(height: 8),
            Divider(
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(8),
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
                          'Starting week: ',
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
                _buildSubmitButton(),
              ],
            ),
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
        _textEditingController.text =
            DateFormat('dd.MM.yyyy').format(_selectedDate);
      });
    }
  }

  Future<void> _saveForm() async {
    //final isValid = _form.();
    //if (!isValid) return;

    //_form.currentState.save();

    print(_titleTextController.text);
    widget.loadedWorkout.name = _titleTextController.text;
    widget.loadedWorkout.description = _descriptionEditingController.text;
    widget.loadedWorkout.period = _period.toInt();
    //Future.delayed(Duration(milliseconds: 300)).then(
    //    (value) => FredericBackend.instance().activityManager.updateData());
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
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8, top: 8),
      child: Theme(
        data: ThemeData(primaryColor: kMainColor),
        child: TextFormField(
          controller: _titleTextController,
          maxLines: 1,
          validator: (value) {
            if (value.isEmpty) return 'Please enter a title';
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
          maxLengthEnforced: true,
          decoration: InputDecoration.collapsed(
            hintText: 'Description',
          ),
          validator: (value) {
            if (value.isEmpty) return 'Please enter a description';
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
