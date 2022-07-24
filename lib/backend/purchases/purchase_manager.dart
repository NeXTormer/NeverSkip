import 'dart:async';

import 'package:frederic/backend/authentication/frederic_auth_event.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseManager {
  late final InAppPurchase _storeInstance;
  final FredericUserManager _userManager;

  static const String PURCHASE_APP_KEY =
      'frederic_purchase_app_for_this_account';
  static const String PURCHASE_APP_DISCOUNTED_KEY =
      'frederic_purchase_app_for_this_account_discounted';

  StreamSubscription<List<PurchaseDetails>>? _purchaseStreamSubscription;

  ProductDetails? purchaseAppProduct;
  ProductDetails? purchaseAppDiscountedProduct;

  PurchaseManager(this._userManager) {
    _storeInstance = InAppPurchase.instance;
  }

  Future<void> initialize() async {
    bool storeIsAvailable = await _storeInstance.isAvailable();

    var response = await _storeInstance
        .queryProductDetails({PURCHASE_APP_KEY, PURCHASE_APP_DISCOUNTED_KEY});

    List<ProductDetails> products = response.productDetails;
    for (var product in products) {
      if (product.id == PURCHASE_APP_KEY) {
        purchaseAppProduct = product;
        continue;
      }
      if (product.id == PURCHASE_APP_DISCOUNTED_KEY) {
        purchaseAppDiscountedProduct = product;
        continue;
      }
    }
  }

  void startFreeTrial() {
    _userManager.state.startTrial();
    _userManager.userDataChanged();
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
