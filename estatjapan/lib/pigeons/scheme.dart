import 'package:pigeon/pigeon.dart';

class PurchaseModel {
  late bool isPurchase;
}

@HostApi()
abstract class HostPurchaseModelApi {
  PurchaseModel getPurchaseModel();
}
