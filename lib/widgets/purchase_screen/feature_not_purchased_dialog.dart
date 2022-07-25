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
      actionText: 'Buy',
      title: 'Trial period over',
      childText:
          'Your trial period is over. You have to buy the app in order to use all its features again.',
      onConfirm: () => Navigator.push(
          context, MaterialPageRoute(builder: (c) => PurchaseScreen())),
    );
  }
}
