import 'package:flutter/material.dart';

class ActivityFlexibleAppbar extends StatefulWidget {
  @override
  _ActivityFlexibleAppbarState createState() => _ActivityFlexibleAppbarState();
}

class _ActivityFlexibleAppbarState extends State<ActivityFlexibleAppbar> {
  final double appbarHeight = 20;
  bool _arms = false;
  bool _chest = false;
  bool _back = false;
  bool _abs = false;
  bool _legs = false;
  bool _weighted = false;
  bool _bodyweight = false;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    Widget buildLabel(String title, bool filterOption) {
      return filterOption
          ? Container(
              height: 25,
              width: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(170, 255, 165, 0),
                border: Border.all(
                  width: 1.0,
                  color: Colors.orange[50],
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ),
            )
          : Container(
              height: 25,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.black26,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14.0, color: Colors.black45),
                ),
              ),
            );
    }

    return Container(
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 245,
                          height: 30,
                          child: TextField(
                            autofocus: false,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _weighted = !_weighted;
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: _weighted
                                      ? Color.fromARGB(170, 255, 165, 0)
                                      : Colors.transparent,
                                  border: Border.all(
                                    width: 1.0,
                                    color: _weighted
                                        ? Colors.orange[50]
                                        : Colors.black26,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 25,
                                  color:
                                      _weighted ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _bodyweight = !_bodyweight;
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: _bodyweight
                                      ? Color.fromARGB(170, 255, 165, 0)
                                      : Colors.transparent,
                                  border: Border.all(
                                    width: 1.0,
                                    color: _bodyweight
                                        ? Colors.orange[50]
                                        : Colors.black26,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.handyman,
                                  size: 25,
                                  color:
                                      _bodyweight ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _arms = !_arms;
                            });
                          },
                          child: buildLabel('Arms', _arms),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _chest = !_chest;
                              });
                            },
                            child: buildLabel('Chest', _chest)),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _back = !_back;
                              });
                            },
                            child: buildLabel('Back', _back)),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _abs = !_abs;
                              });
                            },
                            child: buildLabel('Abs', _abs)),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _legs = !_legs;
                              });
                            },
                            child: buildLabel('Legs', _legs)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
