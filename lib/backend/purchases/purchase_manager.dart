import 'dart:async';

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

    _purchaseStreamSubscription =
        _storeInstance.purchaseStream.listen(_onPurchaseStreamUpdated);
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
        purchaseParam: PurchaseParam(
            productDetails: discount
                ? purchaseAppDiscountedProduct!
                : purchaseAppProduct!));
    return '';
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

  void discard() {
    _purchaseStreamSubscription?.cancel();
  }
}
