import 'package:flutter/material.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:intl/intl.dart';

class WorkoutCard extends StatefulWidget {
  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool _isActive = false;

  Widget _buildActiveStatusButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _isActive = !_isActive;
        });
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Active: '),
            _isActive == true
                ? Icon(
                    Icons.done_all,
                    color: Colors.greenAccent[400],
                  )
                : Icon(
                    Icons.clear,
                    color: Colors.red,
                  )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(EditWorkoutScreen.routeName);
      },
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.1,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
        ),
        child: Stack(
          children: [
            Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 400,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                    child: Image.network(
                      'https://www.fitforfun.de/files/images/201712/1/istock-628092286,276242_m_n.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Summer Body',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'This here is the description',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Created on: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('dd.MM.yyyy').format(
                              DateTime.now(),
                            ),
                          )
                        ],
                      ),
                    ),
                    _buildActiveStatusButton(),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 10.0,
              top: 10,
              child: InkWell(
                onTap: () => print('Share...'),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.share,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10.0,
              top: 10,
              child: InkWell(
                onTap: () => print('Settings...'),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
