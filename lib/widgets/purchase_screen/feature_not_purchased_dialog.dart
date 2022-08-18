import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/screens/purchase_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';

class FeatureNotPurchasedDialog extends StatelessWidget {
  const FeatureNotPurchasedDialog({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showDialog(
        context: context, builder: (c) => FeatureNotPurchasedDialog());
  }

  @override
  Widget build(BuildContext context) {
    return FredericActionDialog(
      actionText: tr('trial.trial_over_dialog.buy'),
      title: tr('trial.trial_over_dialog.title'),
      childText: tr('trial.trial_over_dialog.description'),
      onConfirm: () => Navigator.push(
          context, MaterialPageRoute(builder: (c) => PurchaseScreen())),
    );
  }
}
