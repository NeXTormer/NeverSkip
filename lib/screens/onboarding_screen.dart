import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/bottom_navigation_screen.dart';
import 'package:frederic/screens/screens.dart';
import 'package:introduction_screen/introduction_screen.dart';

const String _recordDescription =
    'Visualize your best performances and keep yourself motivated.';
const String _goalDescription =
    'Set personal goals that you want to accomplish within a certain time frame.';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return BottomNavigationScreen(
        [
          FredericScreen(
            screen: HomeScreen(),
            icon: ExtraIcons.person,
            label: 'Home',
          ),
          FredericScreen(
            screen: CalendarScreen(),
            icon: ExtraIcons.calendar,
            label: 'Calendar',
          ),
          FredericScreen(
            screen: ActivityListScreen(),
            icon: ExtraIcons.dumbbell,
            label: 'Exercises',
          ),
          FredericScreen(
            screen: WorkoutListScreen(),
            icon: ExtraIcons.statistics,
            label: 'Workouts',
          ),
        ],
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    const _bodyStyle = TextStyle(fontSize: 16, color: Colors.black);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    Widget _titleText(String text) => Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ));
    Widget _bodyText(String text, {bool bold = false}) => Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: bold ? FontWeight.w700 : FontWeight.normal),
        );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          image: Image(
            colorBlendMode: BlendMode.screen,
            fit: BoxFit.scaleDown,
            image: AssetImage('assets/images/introduction.png'),
          ),
          titleWidget: _titleText('Personal records and goals'),
          bodyWidget: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Use the ', style: _bodyStyle),
                  Icon(Icons.add, color: Colors.black, size: 22),
                  Text(' to create a new personal', style: _bodyStyle),
                ],
              ),
              Text('record or goal\n', style: _bodyStyle),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bodyText('Visualize your best '),
                  _bodyText('performances ', bold: true),
                  _bodyText('and')
                ],
              ),
              _bodyText('keep yourself motivated\n'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bodyText('Set personal '),
                  _bodyText('goals ', bold: true),
                  _bodyText('that you want to')
                ],
              ),
              _bodyText('accomplish within a certain time frame.'),
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: _titleText('Learn as you go'),
          bodyWidget: _bodyText(
              'Download the Stockpile app and master the market with our mini-lesson.'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: _titleText('Kids and teens'),
          bodyWidget: _bodyText(
              'Kids and teens can track their stocks 24/7 and place trades that you approve.'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
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
