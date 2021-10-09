import 'package:pigeon/pigeon.dart';

class PurchaseModel {
  late bool isPurchase;
}

@HostApi()
abstract class HostPurchaseModelApi {
  PurchaseModel getPurchaseModel();
}

@FlutterApi()
abstract class FlutterPurchaseModelApi {
  void sendPurchaseModel(PurchaseModel purchaseModel);
}
