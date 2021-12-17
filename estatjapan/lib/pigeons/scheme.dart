import 'package:pigeon/pigeon.dart';

class PurchaseModel {
  late bool isPurchase;
  late bool isUsedTrial;
}

@HostApi()
abstract class HostPurchaseModelApi {
  PurchaseModel getPurchaseModel();
  bool requestPurchaseModel();
  bool restorePurchaseModel();
}

@FlutterApi()
abstract class FlutterPurchaseModelApi {
  void sendPurchaseModel(PurchaseModel purchaseModel);
}
