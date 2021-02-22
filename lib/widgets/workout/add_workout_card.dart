import 'package:flutter/material.dart';

class AddWorkoutCard extends StatefulWidget {
  @override
  _AddWorkoutCardState createState() => _AddWorkoutCardState();
}

class _AddWorkoutCardState extends State<AddWorkoutCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          child: Column(
            children: [
              Stack(
                children: [
                  Image(
                    image: NetworkImage(
                        'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg'),
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text('hello'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Theme(
                  data: ThemeData(primaryColor: Colors.orangeAccent),
                  child: TextFormField(
                    maxLength: 30,
                    decoration: InputDecoration(
                      icon: Icon(Icons.fitness_center),
                      labelText: 'Title',
                      suffixIcon: Icon(Icons.check_circle),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
