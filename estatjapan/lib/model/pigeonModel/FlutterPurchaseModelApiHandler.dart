import 'PurchaseModelApi.dart';

typedef PurchaseModelReceived = void Function(PurchaseModel purchaseModel);

class FlutterPurchaseModelApiHandler extends FlutterPurchaseModelApi {
  FlutterPurchaseModelApiHandler(this.callback);

  final PurchaseModelReceived callback;

  @override
  void sendPurchaseModel(PurchaseModel purchaseModel) {
    assert(
      purchaseModel != null,
      'Non-null book expected from FlutterBookApi.displayBookDetails call.',
    );
    callback(purchaseModel);
  }
}
