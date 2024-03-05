import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/frederic_backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
        backgroundColor: theme.accentColorLight,
        body: SingleChildScrollView(
          child: BlocBuilder<FredericUserManager, FredericUser>(
              builder: (context, user) {
            if (user.hasPurchased) {
              Future(() {
                Navigator.of(context).pop();
                FredericBackend.instance.toastManager
                    .showPurchaseSuccessfulToast(context);
              });
            }
            return WillPopScope(
              onWillPop: () async => !(user.tempPurchaseIsPending ?? false),
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
                            image: AssetImage(
                                'assets/images/abdominal-bench.png')),
                      ),
                      Text(
                        tr('trial.purchase_app'),
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
                      buildListEntry(tr('trial.list_item_1')),
                      buildListEntry(tr('trial.list_item_2')),
                      buildListEntry(tr('trial.list_item_3')),
                      const SizedBox(height: 30),
                      if (user.tempPurchaseIsPending ?? false)
                        Container(
                          child: Text(
                            tr('trial.purchase_pending_text'),
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.red,
                                letterSpacing: 0.2),
                          ),
                        ),
                      if (!(user.tempPurchaseIsPending ?? false))
                        const SizedBox(height: 30),
                      const SizedBox(height: 30),
                      Text(
                        tr('trial.discount_description'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 0.2),
                      ),
                      const SizedBox(height: 18),
                      FredericButton(
                          tr('trial.purchase_button_discount', args: [
                            FredericBackend
                                .instance.purchaseManager.discountPrince
                          ]),
                          loading: user.hasActiveTrial &&
                              (user.tempPurchaseIsPending ?? false),
                          mainColor: user.hasActiveTrial
                              ? theme.mainColor
                              : theme.disabledGreyColor, onPressed: () {
                        if (!user.hasActiveTrial) return;
                        FredericBackend.instance.purchaseManager
                            .purchaseForCurrentAccount(discount: true);
                      }),
                      const SizedBox(height: 18),
                      FredericButton(
                          tr('trial.purchase_button_normal', args: [
                            FredericBackend.instance.purchaseManager.normalPrice
                          ]),
                          loading: (!user.hasActiveTrial) &&
                              (user.tempPurchaseIsPending ?? false),
                          mainColor: user.hasActiveTrial
                              ? theme.disabledGreyColor
                              : theme.mainColor, onPressed: () {
                        if (user.hasActiveTrial) return;
                        FredericBackend.instance.purchaseManager
                            .purchaseForCurrentAccount(discount: false);
                      }),
                      const SizedBox(height: 18),
                      Text(
                        tr('trial.help_text'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black54,
                            letterSpacing: 0.2),
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: () {
                          FredericBackend.instance.purchaseManager
                              .restorePurchase();
                        },
                        child: Text(
                          'Restore purchase',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black87,
                              letterSpacing: 0.2),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          }),
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
