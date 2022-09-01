import 'dart:async' show Future;
import 'dart:convert';

import 'package:estatjapan/model/pigeonModel/PurchaseModelApi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const isThemeFollowSystemKey = "isThemeFollowSystemKey";
const isThemeDarkModeKey = "isThemeDarkModeKey";

class AppConfig extends ChangeNotifier {
  final String android_inline_banner;
  final String android_inline_native;
  final String android_appid;
  final String ios_inline_banner;
  final String ios_inline_native;
  final String ios_appid;
  final String estatAppId;
  PurchaseModel? purchaseModel;
  bool isThemeFollowSystem;
  bool isThemeDarkMode;

  static late final AppConfig shared;

  AppConfig._internal(
      {required this.android_inline_banner,
      required this.android_inline_native,
      required this.android_appid,
      required this.ios_inline_banner,
      required this.ios_inline_native,
      required this.ios_appid,
      required this.estatAppId,
      required this.isThemeFollowSystem,
      required this.isThemeDarkMode});

  static Future<AppConfig> forEnvironment() async {
    const env = kReleaseMode ? 'prod' : 'dev';
    final contents = await rootBundle.loadString(
      'lib/config/$env.json',
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    final isThemeFollowSystem = pref.getBool(isThemeFollowSystemKey) ?? true;
    final isThemeDarkMode = pref.getBool(isThemeDarkModeKey) ?? false;
    // decode our json
    final json = jsonDecode(contents);
    shared = AppConfig._internal(
        android_inline_banner: json['android_inline_banner'],
        android_inline_native: json['android_inline_native'],
        android_appid: json['android_appid'],
        ios_inline_banner: json['ios_inline_banner'],
        ios_inline_native: json['ios_inline_native'],
        ios_appid: json['ios_appid'],
        estatAppId: json['estatAppId'],
        isThemeFollowSystem: isThemeFollowSystem,
        isThemeDarkMode: isThemeDarkMode);
    return shared;
  }

  void setThemeFollowSystem(bool isThemeFollowSystem) {
    this.isThemeFollowSystem = isThemeFollowSystem;
    SharedPreferences.getInstance().then((value) {
      value.setBool(isThemeFollowSystemKey, isThemeFollowSystem);
      notifyListeners();
    });
  }

  void setThemeDarkModeKey(bool isThemeDarkMode) {
    this.isThemeDarkMode = isThemeDarkMode;
    SharedPreferences.getInstance().then((value) {
      value.setBool(isThemeDarkModeKey, isThemeDarkMode);
      notifyListeners();
    });
  }

  ThemeMode getThemeMode() {
    if (isThemeFollowSystem) {
      return ThemeMode.system;
    } else if (isThemeDarkMode) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
}
