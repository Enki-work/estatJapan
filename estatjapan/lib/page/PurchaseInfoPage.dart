import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:estatjapan/model/pigeonModel/PurchaseModelApi.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/ConsumableStore.dart';

final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'com.estatjapan.purchase.ads';
const String _kUpgradeId = '_kUpgradeId';
const String _kSilverSubscriptionId = 'com.estatjapan.purchase.deleteads';
const String _kGoldSubscriptionId = '_kGoldSubscriptionId';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class PurchaseInfoPage extends StatefulWidget {
  const PurchaseInfoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PurchaseInfoPageState();
  }
}

class _PurchaseInfoPageState extends State<PurchaseInfoPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  ProductDetails? get subscriptionDetail {
    return _products
        .where((element) => element.id == _kSilverSubscriptionId)
        .firstOrNull;
  }

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
              // ignore: deprecated_member_use
              primary: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == _kSilverSubscriptionId &&
        purchases[_kGoldSubscriptionId] != null) {
      oldSubscription =
          purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
    } else if (productDetails.id == _kGoldSubscriptionId &&
        purchases[_kSilverSubscriptionId] != null) {
      oldSubscription =
          purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: const Text("広告を削除するとは"),
        ),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(
                    top: 60, left: 16, right: 16, bottom: 16),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(children: [
                          Image.asset('images/app_icon.png',
                              width: MediaQuery.of(context).size.width * 0.3),
                          const SizedBox(height: 8),
                          const Text(
                            "在留資格統計",
                            style: TextStyle(fontSize: 20),
                          ),
                        ])),
                    Expanded(
                        flex: 2,
                        child: Scrollbar(
                            // 显示进度条
                            child: SingleChildScrollView(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 23, right: 23, bottom: 16),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                46,
                                        child: Card(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16, bottom: 16),
                                              child: Column(children: const [
                                                Text(
                                                  "広告削除プランの機能",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  "アプリ内の広告非表示",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )
                                              ])),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      const Text(
                                        "購入の確認・注意点",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Divider(
                                        height: 0.5,
                                        color: Colors.grey[120],
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎「自動継続課金」について",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "契約期間は、期限が切れる24時間以内に自動更新の解除をされない場合、自動更新されます。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎解約方法について",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        () {
                                          if (Platform.isIOS) {
                                            return "設定＞Apple ID＞サブスクリプション＞アプリ名＞サブスクリプションからクアンセルで解約ができます。";
                                          } else if (Platform.isAndroid) {
                                            return "Playストアアプリ＞設定＞定期購入＞アプリ名から解約ができます。";
                                          } else {
                                            return "";
                                          }
                                        }(),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎契約期間の確認",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "解約方法と同じ手順で契約時間の確認いただけます。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎購入の復元について",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "契約中の場合、購入情報を復元するから、復元することが可能です。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎キャンセルについて",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        () {
                                          if (Platform.isIOS) {
                                            return "当月分のキャンセルはお受けておりません。App Store経由で課金されます。";
                                          } else if (Platform.isAndroid) {
                                            return "当月分のキャンセルはお受けておりません。Google Play経由で課金されます。";
                                          } else {
                                            return "";
                                          }
                                        }(),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 30),
                                      const Text(
                                        "利用規約・プライバシー",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Divider(
                                        height: 0.5,
                                        color: Colors.grey[120],
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎利用規約・プライバシーについて",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          children: [
                                            TextButton.icon(
                                              icon: const Icon(
                                                  Icons.supervised_user_circle),
                                              label: const Text("利用規約"),
                                              onPressed: () {
                                                _launchURL(
                                                    "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/");
                                              },
                                            ),
                                            TextButton.icon(
                                              icon:
                                                  const Icon(Icons.privacy_tip),
                                              label: const Text("プライバシー"),
                                              onPressed: () {
                                                _launchURL(
                                                    "http://zairyu.maoxiaoqiang.net/privacypolicy.html");
                                              },
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.topCenter,
                                      ),
                                      const Text(
                                        "第三者に個人を特定できる情報を提供することはできません。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎データ解析について",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "継続的なアプリ改善のため、アクセス解析をしております。解析データは匿名で収集されており、個人を特定するものではありません。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎免責事項",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "利用者が当アプリを使用したことにより生じた、いかなる損失や損害などの被害に関して、開発元は責任を負わないものとします。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎ありがとう",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "最後まできっちり読んでいただいてありがとうございます。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ])))),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(
                              MediaQuery.of(context).size.width * 0.7, 60))),
                      icon: const Icon(Icons.send),
                      label: const Text("広告削除課金を申し込む"),
                      onPressed: () async {
                        // bool result =
                        // await HostPurchaseModelApi().requestPurchaseModel();
                        // if (result) Navigator.pop(context);
                        if (subscriptionDetail != null) {
                          purchase(subscriptionDetail!);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Text("無料期間終了後${subscriptionDetail?.price}/月"),
                  ],
                ))));
  }

  void purchase(ProductDetails productDetails) {
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
      // verify the latest status of you your subscription by using server side receipt validation
      // and update the UI accordingly. The subscription purchase status shown
      // inside the app may not be accurate.
      final GooglePlayPurchaseDetails? oldSubscription =
          _getOldSubscription(productDetails, purchases);

      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                  prorationMode: ProrationMode.immediateWithTimeProration,
                )
              : null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );
    }

    if (productDetails.id == _kConsumableId) {
      _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
    } else {
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void _launchURL(String _url) async => await canLaunchUrl(Uri.parse(_url))
      ? launchUrl(Uri.parse(_url))
      : throw 'Could not launch $_url';
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
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
