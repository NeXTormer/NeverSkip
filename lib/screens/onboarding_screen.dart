import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    TextSpan _bodyText(String text, {bool bold = false}) => TextSpan(
        text: text,
        style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: bold ? FontWeight.w700 : FontWeight.normal));

    Widget _titleText(String text) => Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ));

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          image: Image(
            height: 270,
            colorBlendMode: BlendMode.screen,
            fit: BoxFit.scaleDown,
            image: AssetImage('assets/images/introduction_screen_1.png'),
          ),
          titleWidget: _titleText('Personal records and goals'),
          bodyWidget: Column(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    _bodyText('Use the '),
                    WidgetSpan(
                        child: Icon(Icons.add, color: Colors.black, size: 22)),
                    _bodyText(
                        ' to create a new personal record or goal.\n\nVisualize your best '),
                    _bodyText('performances', bold: true),
                    _bodyText(' and keep yourself motivated.\n\n'),
                    _bodyText('Set personal '),
                    _bodyText('goals', bold: true),
                    _bodyText(
                        ' that you want to accomplish within a certain time frame.')
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          image: Image(
            height: 270,
            colorBlendMode: BlendMode.screen,
            fit: BoxFit.scaleDown,
            image: AssetImage('assets/images/introduction_screen_2.png'),
          ),
          titleWidget: _titleText('Log your activity progress'),
          bodyWidget: Column(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    _bodyText(
                        'Click on any activity in your calendar or workoutplan to log '),
                    _bodyText('kg', bold: true),
                    _bodyText(', '),
                    _bodyText('reps', bold: true),
                    _bodyText(', '),
                    _bodyText('or '),
                    _bodyText('sets', bold: true),
                    _bodyText('.\n\nTrack your training '),
                    _bodyText('performances', bold: true),
                    _bodyText(' and increase progressively.')
                  ],
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          image: Image(
            height: 270,
            colorBlendMode: BlendMode.screen,
            fit: BoxFit.scaleDown,
            image: AssetImage('assets/images/introduction_screen_3.png'),
          ),
          titleWidget: _titleText('Your personal workout planner'),
          bodyWidget: Column(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    _bodyText('Use the planner to create your '),
                    _bodyText('individual', bold: true),
                    _bodyText(
                        ' trainingsplan. \n\nChoose the perfect exercises for your and your goal from an '),
                    _bodyText('extensive', bold: true),
                    _bodyText(' selection.'),
                    _bodyText('\n\nActivate individual workout plan to '),
                    _bodyText('link', bold: true),
                    _bodyText(' them to the integrated '),
                    _bodyText('calendar', bold: true),
                    _bodyText(' so you never miss a trainings day again.'),
                  ],
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => Navigator.of(context).pop(),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
