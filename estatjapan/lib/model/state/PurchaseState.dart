import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'PurchaseState.freezed.dart';

@freezed
class PurchaseState with _$PurchaseState {
  const factory PurchaseState({
    @Default(false) bool isAdDeletedDone,
    @Default([]) List<String> consumables,
    StreamSubscription<List<PurchaseDetails>>? subscription,
    @Default([]) List<String> notFoundIds,
    @Default([]) List<ProductDetails> products,
    @Default([]) List<PurchaseDetails> purchases,
    @Default(false) bool isAvailable,
    @Default(false) bool purchasePending,
    @Default(false) bool loading,
    String? queryProductError,
    ProductDetails? adDeletedSubscriptionDetail,
  }) = _PurchaseState;
}
