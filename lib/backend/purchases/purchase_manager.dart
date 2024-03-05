import 'dart:async';
import 'dart:io';

import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

//
// https://levelup.gitconnected.com/how-to-integrate-in-app-purchase-in-flutter-ios-54a66b7eff0b
//
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

  String normalPrice = '';
  String discountPrince = '';

  bool isAvailable = false;

  PurchaseManager(this._userManager) {
    _storeInstance = InAppPurchase.instance;
  }

  Future<void> initialize() async {
    bool storeIsAvailable = await _storeInstance.isAvailable();

    if (!storeIsAvailable) return;
    isAvailable = true;

    _purchaseStreamSubscription =
        _storeInstance.purchaseStream.listen(_onPurchaseStreamUpdated);

    var response = await _storeInstance
        .queryProductDetails({PURCHASE_APP_KEY, PURCHASE_APP_DISCOUNTED_KEY});

    List<ProductDetails> products = response.productDetails;
    for (var product in products) {
      if (product.id == PURCHASE_APP_KEY) {
        purchaseAppProduct = product;
        normalPrice = product.price;
        continue;
      }
      if (product.id == PURCHASE_APP_DISCOUNTED_KEY) {
        purchaseAppDiscountedProduct = product;
        discountPrince = product.price;
        continue;
      }
    }

    if (Platform.isIOS) {
      var iosPlatformAddition = _storeInstance
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(FredericPaymentQueueDelegate());
    }
  }

  void startFreeTrial() {
    _userManager.state.startTrial();
    _userManager.userDataChanged();
  }

  Future<String> purchaseForCurrentAccount({required bool discount}) async {
    print('Purchase button pressed, discount: $discount');
    if (discount) {
      assert(_userManager.state.hasActiveTrial);
    }

    if (_userManager.state.hasPurchased) {
      return 'User already has a license';
    }

    if (purchaseAppDiscountedProduct == null || purchaseAppProduct == null) {
      return 'Error connecting to store';
    }

    bool success = await _storeInstance.buyConsumable(
        autoConsume: true,
        purchaseParam: PurchaseParam(
            productDetails: discount
                ? purchaseAppDiscountedProduct!
                : purchaseAppProduct!));

    return success ? 'Success' : 'Error';
  }

  void _onPurchaseStreamUpdated(List<PurchaseDetails> detailsList) async {
    for (var detail in detailsList) {
      if (detail.status == PurchaseStatus.purchased ||
          detail.status == PurchaseStatus.restored) {
        _userManager.state.onPurchased();
        _userManager.state.tempPurchaseIsPending = false;
        _userManager.state.tempPurchaseError = false;

        await _userManager.userDataChanged(true);
      } else if (detail.status == PurchaseStatus.pending) {
        _userManager.state.tempPurchaseIsPending = true;
        await _userManager.userDataChanged(true);
      } else if (detail.status == PurchaseStatus.error) {
        _userManager.state.tempPurchaseError = true;
        _userManager.state.tempPurchaseIsPending = false;

        await _userManager.userDataChanged(true);
      } else if (detail.status == PurchaseStatus.canceled) {
        _userManager.state.tempPurchaseError = false;
        _userManager.state.tempPurchaseIsPending = false;

        await _userManager.userDataChanged();
      }

      if (detail.pendingCompletePurchase) {
        await _storeInstance.completePurchase(detail);
      }
    }
  }

  Future<void> restorePurchase() {
    return _storeInstance.restorePurchases();
  }

  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _storeInstance
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _purchaseStreamSubscription?.cancel();
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class FredericPaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
