import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen(this.user, {Key? key}) : super(key: key);

  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = user.hasActiveTrial;

    return FredericScaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                    'Purchase NeverSkip',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: theme.mainColor,
                        letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trial: ${user.getTrialDaysLeft() >= 0 ? "${user.getTrialDaysLeft()} days remaining" : "expired"}',
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
                    'If you purchase within the trial period you get a €2 discount!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 18),
                  FredericButton('Purchase during trial for €4,99',
                      mainColor: hasDiscount
                          ? theme.mainColor
                          : theme.disabledGreyColor, onPressed: () {
                    if (!hasDiscount) return;
                  }),
                  const SizedBox(height: 18),
                  FredericButton('Purchase after trial for €6,99',
                      mainColor: hasDiscount
                          ? theme.disabledGreyColor
                          : theme.mainColor, onPressed: () {
                    if (hasDiscount) return;
                  }),
                  const SizedBox(height: 18),

                  // Text(
                  //   'Restore purchase',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //       letterSpacing: 0.2),
                  // ),
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
