import 'dart:async' show Future;
import 'dart:convert';

import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

import '../state/AppConfigState.dart';
import '../state/PurchaseModel.dart';

const isThemeFollowSystemKey = "isThemeFollowSystemKey";
const isThemeDarkModeKey = "isThemeDarkModeKey";
const themeFlexSchemeKey = "themeFlexSchemeKey";

class AppConfigNotifier extends StateNotifier<AppConfigState> {
  AppConfigNotifier() : super(AppConfigState(bannerAdModel: BannerAdModel()));

  set purchaseModel(PurchaseModel? purchaseModel) {
    state = state.copyWith(purchaseModel: purchaseModel);
  }

  Future<AppConfigState> forEnvironment() async {
    const env = kReleaseMode ? 'prod' : 'dev';
    final contents = await rootBundle.loadString(
      'lib/config/$env.json',
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    final isThemeFollowSystem = pref.getBool(isThemeFollowSystemKey) ?? true;
    final isThemeDarkMode = pref.getBool(isThemeDarkModeKey) ?? false;
    final themeFlexSchemeName =
        pref.getString(themeFlexSchemeKey) ?? FlexScheme.amber.name;
    // decode our json
    final json = jsonDecode(contents);
    state = state.copyWith(
        android_inline_banner: json['android_inline_banner'],
        android_inline_native: json['android_inline_native'],
        android_open_ads: json['android_open_ads'],
        android_appid: json['android_appid'],
        ios_inline_banner: json['ios_inline_banner'],
        ios_inline_native: json['ios_inline_native'],
        ios_open_ads: json['ios_open_ads'],
        ios_appid: json['ios_appid'],
        estatAppId: json['estatAppId'],
        isThemeFollowSystem: isThemeFollowSystem,
        isThemeDarkMode: isThemeDarkMode,
        themeFlexScheme: FlexScheme.values
            .firstWhere((element) => element.name == themeFlexSchemeName));

    return state;
  }

  void setThemeFollowSystem(bool isThemeFollowSystem) {
    SharedPreferences.getInstance().then((value) {
      value.setBool(isThemeFollowSystemKey, isThemeFollowSystem);
      state = state.copyWith(isThemeFollowSystem: isThemeFollowSystem);
    });
  }

  void setThemeDarkModeKey(bool isThemeDarkMode) {
    SharedPreferences.getInstance().then((value) {
      value.setBool(isThemeDarkModeKey, isThemeDarkMode);
      state = state.copyWith(isThemeDarkMode: isThemeDarkMode);
    });
  }

  set themeFlexSchemeName(String themeFlexSchemeName) {
    SharedPreferences.getInstance().then((value) {
      value.setString(themeFlexSchemeKey, themeFlexSchemeName);
      state = state.copyWith(
          themeFlexScheme: FlexScheme.values
              .firstWhere((element) => element.name == themeFlexSchemeName));
    });
  }
}
