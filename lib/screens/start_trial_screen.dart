import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';

class StartTrialScreen extends StatelessWidget {
  const StartTrialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
        body: SizedBox.expand(
      child: Container(
        color: Colors.white,
        child: Container(
          color: theme.accentColorLight,
          padding: const EdgeInsets.all(48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image(
                    colorBlendMode: BlendMode.screen,
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/images/abdominal-bench.png')),
              ),
              Text(
                'NeverSkip',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: theme.mainColor,
                    letterSpacing: 0.6),
              ),
              const SizedBox(height: 4),
              Text(
                '30 day free trial',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    letterSpacing: 0.2),
              ),
              const SizedBox(height: 32),
              buildListEntry('Plan your workouts'),
              buildListEntry('See your progress'),
              buildListEntry('Stay Motivated'),
              const SizedBox(height: 88),
              Text(
                'You get a generous 30 day free trial, so you have enough time to test and use all features.\n\nIf you purchase the app within the trial period you get a €2 discount!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    letterSpacing: 0.2),
              ),
              const SizedBox(height: 18),
              FredericButton('Start free trial', onPressed: () {}),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildListEntry(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          //const SizedBox(width: 48),
          Icon(Icons.check, color: theme.positiveColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),
          )
        ],
      ),
    );
  }
}
