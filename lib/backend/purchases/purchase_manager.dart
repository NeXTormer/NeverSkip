import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseManager {
  void restore() {
    InAppPurchase.instance.restorePurchases();
  }
}
