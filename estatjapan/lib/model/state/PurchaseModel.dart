import 'package:freezed_annotation/freezed_annotation.dart';

part 'PurchaseModel.freezed.dart';

@freezed
class PurchaseModel with _$PurchaseModel {
  const factory PurchaseModel({
    @Default(false) bool isPurchase,
    @Default(false) bool isUsedTrial,
  }) = _PurchaseModel;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['isPurchase'] = isPurchase;
    pigeonMap['isUsedTrial'] = isUsedTrial;
    return pigeonMap;
  }

  static PurchaseModel decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return PurchaseModel(
        isPurchase: ((pigeonMap['isPurchase'] as bool?) ?? false),
        isUsedTrial: (pigeonMap['isUsedTrial'] as bool?) ?? false);
  }
}
