import 'dart:async';

import 'package:frederic/backend/authentication/frederic_auth_event.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseManager {
  late final InAppPurchase _storeInstance;
  final FredericUserManager _userManager;

  StreamSubscription<List<PurchaseDetails>>? _purchaseStreamSubscription;

  PurchaseManager(this._userManager) {
    _storeInstance = InAppPurchase.instance;
  }

  void purchaseForCurrentAccount() {
    _purchaseStreamSubscription =
        _storeInstance.purchaseStream.listen(_onPurchaseStreamUpdated);

    // PurchaseDetails details = PurchaseDetails(
    //     productID: productID,
    //     verificationData: PurchaseVerificationData(),
    //     transactionDate: DateTime.now(),
    //     status: status);

    // _storeInstance.completePurchase(details);
  }

  void _onPurchaseStreamUpdated(List<PurchaseDetails> detailsList) {
    _userManager.add(FredericPurchaseLicenseEvent());

    _purchaseStreamSubscription?.cancel();
  }
}
