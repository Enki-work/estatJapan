import 'package:freezed_annotation/freezed_annotation.dart';

import 'PurchaseModel.dart';

part 'AppConfigState.freezed.dart';

@freezed
class AppConfigState with _$AppConfigState {
  const factory AppConfigState({
    @Default("") String android_inline_banner,
    @Default("") String android_inline_native,
    @Default("") String android_appid,
    @Default("") String ios_inline_banner,
    @Default("") String ios_inline_native,
    @Default("") String ios_appid,
    @Default("") String estatAppId,
    @Default(true) bool isThemeFollowSystem,
    @Default(false) bool isThemeDarkMode,
    PurchaseModel? purchaseModel,
  }) = _AppConfigState;
}
