import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/authentication_wrapper.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.mainColor,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: Container()),
              Text(
                'Welcome to\nNeverSkip',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    letterSpacing: -1.0,
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Text(
                  'Hey there! We have been working hard to make our dream app for building workout plans and tracking our progress.',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      letterSpacing: -0.4,
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              Text(
                  'We hope you will love using NeverSkip to track and plan your perfect workouts.',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      letterSpacing: -0.4,
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Container()),
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('- Felix & Stefan',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              letterSpacing: -0.4,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              Expanded(flex: 8, child: Container()),
              FredericButton(
                'Lets go!',
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('show_welcome_screen', false);
                  AuthenticationWrapper.rebuild(context);
                },
                textColor: theme.mainColor,
                fontSize: 18,
                mainColor: Colors.white,
              )
            ],
          ),
        ));
  }
}
