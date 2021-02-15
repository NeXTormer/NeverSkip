import 'package:flutter/material.dart';
import 'package:frederic/screens/activity_screen.dart';
import 'package:frederic/screens/calender_screen.dart';
import 'package:frederic/screens/edit_workout_screen.dart';
import 'package:frederic/screens/new_new_new_calendar_screen.dart';
import 'package:frederic/screens/profile_screen_2.dart';
import 'package:frederic/screens/workout_overview_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavDesign extends StatefulWidget {
  final screenIndex;

  BottomNavDesign(this.screenIndex);

  @override
  _BottomNavDesignState createState() => _BottomNavDesignState();
}

class _BottomNavDesignState extends State<BottomNavDesign> {
  int _currentIndex = 0;
  final List<String> _children = [
    ProfileScreen2.routeName,
    NewNewNewCalendarScreen.routeName,
    WorkoutOverviewScreen.routeName,
    ActivityScreen.routeName,
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(1),
              //spreadRadius: -10,
              offset: Offset(0, 15)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: GNav(
            tabActiveBorder: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            selectedIndex: widget.screenIndex,
            onTabChange: (index) {
              Navigator.pushReplacementNamed(context, _children[index]);
            },
            rippleColor: Colors.grey[300],
            hoverColor: Colors.grey[100],
            gap: 8,
            activeColor: Colors.black,
            iconSize: 20,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14.5),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100],
            textStyle: TextStyle(fontSize: 16, color: Colors.black),
            tabs: [
              GButton(
                icon: Icons.person,
                text: 'Profile',
                leading: CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(
                      'http://soziotypen.de/wp-content/uploads/2020/01/Sascha-Huber.jpg'),
                ),
              ),
              GButton(
                icon: Icons.calendar_today,
                text: 'Calendar',
              ),
              GButton(
                icon: Icons.add,
                text: 'Your Workouts',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}