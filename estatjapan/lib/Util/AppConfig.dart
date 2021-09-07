import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String android_inline_banner;
  final String android_inline_native;
  final String android_appid;
  final String estatAppId;

  static late final AppConfig _cache;

  AppConfig._internal(
      {required this.android_inline_banner,
      required this.android_inline_native,
      required this.android_appid,
      required this.estatAppId});

  static Future<AppConfig> forEnvironment() async {
    final env = 'dev';

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);
    _cache = AppConfig._internal(
        android_inline_banner: json['android_inline_banner'],
        android_inline_native: json['android_inline_native'],
        android_appid: json['android_appid'],
        estatAppId: json['estatAppId']);
    return _cache;
  }
}
