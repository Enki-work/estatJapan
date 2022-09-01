import '../state/PurchaseModel.dart';
import 'PurchaseModelApi.dart';

typedef PurchaseModelReceived = void Function(PurchaseModel purchaseModel);

class FlutterPurchaseModelApiHandler extends FlutterPurchaseModelApi {
  FlutterPurchaseModelApiHandler(this.callback);

  final PurchaseModelReceived callback;

  @override
  void sendPurchaseModel(PurchaseModel purchaseModel) {
    callback(purchaseModel);
  }
}
