import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../util/ConsumableStore.dart';
import '../state/PurchaseState.dart';

final bool kAutoConsume = Platform.isIOS || true;

const String kConsumableId = 'com.estatjapan.purchase.ads';
const String kUpgradeId = 'kUpgradeId';
const String kSilverSubscriptionId = 'com.estatjapan.purchase.deleteads';
const String kGoldSubscriptionId = 'kGoldSubscriptionId';
const List<String> kProductIds = <String>[
  kConsumableId,
  kUpgradeId,
  kSilverSubscriptionId,
  kGoldSubscriptionId,
];
const isAdDeletedDoneKey = "isAdDeletedDoneKey";

class PurchaseNotifier extends StateNotifier<PurchaseState> {
  PurchaseNotifier() : super(const PurchaseState());

  final InAppPurchase inAppPurchase = InAppPurchase.instance;

  Future<void> initStoreInfo() async {
    final subscription = state.purchaseUpdated.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      state.subscription?.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    final bool isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      state = state.copyWith(
        isAvailable: isAvailable,
        products: <ProductDetails>[],
        purchases: <PurchaseDetails>[],
        notFoundIds: <String>[],
        consumables: <String>[],
        purchasePending: false,
        loading: false,
        subscription: subscription,
      );

      return;
    }
    var paymentWrapper = SKPaymentQueueWrapper();
    var transactions = await paymentWrapper.transactions();
    for (var transaction in transactions) {
      await paymentWrapper.finishTransaction(transaction);
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await inAppPurchase.queryProductDetails(kProductIds.toSet());
    final adDeletedSubscriptionDetail = productDetailResponse.productDetails
        .where((element) => element.id == kSilverSubscriptionId)
        .firstOrNull;
    if (productDetailResponse.error != null) {
      state = state.copyWith(
        isAvailable: isAvailable,
        products: productDetailResponse.productDetails,
        purchases: <PurchaseDetails>[],
        notFoundIds: productDetailResponse.notFoundIDs,
        consumables: <String>[],
        purchasePending: false,
        loading: false,
        queryProductError: productDetailResponse.error!.message,
        adDeletedSubscriptionDetail: adDeletedSubscriptionDetail,
        subscription: subscription,
      );
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      state = state.copyWith(
        isAvailable: isAvailable,
        products: productDetailResponse.productDetails,
        purchases: <PurchaseDetails>[],
        notFoundIds: productDetailResponse.notFoundIDs,
        consumables: <String>[],
        purchasePending: false,
        loading: false,
        queryProductError: null,
        adDeletedSubscriptionDetail: adDeletedSubscriptionDetail,
        subscription: subscription,
      );
      return;
    }

    final List<String> consumables = await ConsumableStore.load();

    state = state.copyWith(
      isAvailable: isAvailable,
      products: productDetailResponse.productDetails,
      notFoundIds: productDetailResponse.notFoundIDs,
      consumables: consumables,
      purchasePending: false,
      adDeletedSubscriptionDetail: adDeletedSubscriptionDetail,
      subscription: subscription,
    );
  }

  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    // if (purchaseDetailsList.isEmpty) {
    //   Get.snackbar('error', '課金情報がありません', backgroundColor: Colors.white);
    // }

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }

        if (purchaseDetails.error?.message != null) {
          Get.snackbar('error', purchaseDetails.error!.message,
              backgroundColor: Colors.white);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }
  //
  // Widget buildRestoreButton() {
  //   if (loading) {
  //     return Container();
  //   }
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(4.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: <Widget>[
  //         TextButton(
  //           style: TextButton.styleFrom(
  //             backgroundColor: Theme.of(context).primaryColor,
  //             // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
  //             // ignore: deprecatedmemberuse
  //             primary: Colors.white,
  //           ),
  //           onPressed: () => inAppPurchase.restorePurchases(),
  //           child: const Text('Restore purchases'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();

    state = state.copyWith(consumables: consumables);
  }

  void showPendingUI() {
    state = state.copyWith(purchasePending: true);
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      state = state.copyWith(purchasePending: true, consumables: consumables);
    } else {
      final adDeleted = (purchaseDetails.productID == kSilverSubscriptionId);
      if (adDeleted) {
        isAdDeletedDone = true;
        state = state.copyWith(
            purchasePending: false,
            isAdDeletedDone: true,
            purchases: state.purchases + [purchaseDetails]);
      } else {
        state = state.copyWith(
            purchasePending: false,
            isAdDeletedDone: false,
            purchases: state.purchases + [purchaseDetails]);
      }
      if (kDebugMode) {
        print(state.isAdDeletedDone);
      }
    }
  }

  void handleError(IAPError error) {
    state = state.copyWith(purchasePending: false);
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  verifyPurchase` failed.
  }

  // Future<void> confirmPriceChange(BuildContext context) async {
  //   if (Platform.isAndroid) {
  //     final InAppPurchaseAndroidPlatformAddition androidAddition = inAppPurchase
  //         .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
  //     final BillingResultWrapper priceChangeConfirmationResult =
  //         await androidAddition.launchPriceChangeConfirmationFlow(
  //       sku: 'purchaseId',
  //     );
  //     if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Price change accepted'),
  //       ));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(
  //           priceChangeConfirmationResult.debugMessage ??
  //               'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
  //         ),
  //       ));
  //     }
  //   }
  //   if (Platform.isIOS) {
  //     final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
  //         inAppPurchase
  //             .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
  //     await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
  //   }
  // }

  GooglePlayPurchaseDetails? getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscriptionsilver' & 'subscriptiongold'.
    // The 'subscriptionsilver' subscription can be upgraded to 'subscriptiongold' and
    // the 'subscriptiongold' subscription can be downgraded to 'subscriptionsilver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == kSilverSubscriptionId &&
        purchases[kGoldSubscriptionId] != null) {
      oldSubscription =
          purchases[kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
    } else if (productDetails.id == kGoldSubscriptionId &&
        purchases[kSilverSubscriptionId] != null) {
      oldSubscription =
          purchases[kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = state
          .inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    state.subscription?.cancel();
    super.dispose();
  }

  void purchase() {
    final productDetails = state.adDeletedSubscriptionDetail;
    if (productDetails == null) return;
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            state.purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        state.inAppPurchase.completePurchase(purchase);
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
          getOldSubscription(productDetails, purchases);

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

    if (productDetails.id == kConsumableId) {
      state.inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: kAutoConsume);
    } else {
      state.inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void restorePurchases() {
    state.inAppPurchase.restorePurchases();
  }

  set isAdDeletedDone(bool isAdDeletedDone) {
    SharedPreferences.getInstance().then((value) {
      value.setBool(isAdDeletedDoneKey, isAdDeletedDone);
    });
  }

  Future<bool> getIsAdDeletedDone() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final isAdDeletedDone = pref.getBool(isAdDeletedDoneKey) ?? false;
    state = state.copyWith(isAdDeletedDone: isAdDeletedDone);
    return isAdDeletedDone;
  }
}

extension InAppPurchaseInfo on PurchaseState {
  InAppPurchase get inAppPurchase => InAppPurchase.instance;
  Stream<List<PurchaseDetails>> get purchaseUpdated =>
      inAppPurchase.purchaseStream;
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
