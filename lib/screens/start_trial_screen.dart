import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';

class StartTrialScreen extends StatelessWidget {
  const StartTrialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: FredericScaffold(
          backgroundColor: theme.accentColorLight,
          body: SingleChildScrollView(
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
                    tr('app_name'),
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: theme.mainColor,
                        letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr('trial.day_free_trial_text', args: [
                      FredericBackend.instance.defaults.trialDuration.toString()
                    ]),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 32),
                  buildListEntry(tr('trial.list_item_1')),
                  buildListEntry(tr('trial.list_item_2')),
                  buildListEntry(tr('trial.list_item_3')),
                  const SizedBox(height: 88),
                  Text(
                    tr('trial.trial_description', args: [
                      FredericBackend.instance.defaults.trialDuration.toString()
                    ]),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 0.2),
                  ),
                  const SizedBox(height: 18),
                  FredericButton(tr('trial.start_trial_button'), onPressed: () {
                    FredericBackend.instance.purchaseManager.startFreeTrial();
                    Navigator.of(context).pop();
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          )),
    );
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
