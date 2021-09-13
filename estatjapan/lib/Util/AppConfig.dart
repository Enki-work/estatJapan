import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  final String android_inline_banner;
  final String android_inline_native;
  final String android_appid;
  final String ios_inline_banner;
  final String ios_inline_native;
  final String ios_appid;
  final String estatAppId;

  static late final AppConfig shared;

  AppConfig._internal(
      {required this.android_inline_banner,
      required this.android_inline_native,
      required this.android_appid,
  required this.ios_inline_banner,
  required this.ios_inline_native,
  required this.ios_appid,
      required this.estatAppId});

  static Future<AppConfig> forEnvironment() async {
    final env = kReleaseMode ? 'prod' : 'dev';
    final contents = await rootBundle.loadString(
      'lib/config/$env.json',
    );
    // decode our json
    final json = jsonDecode(contents);
    shared = AppConfig._internal(
        android_inline_banner: json['android_inline_banner'],
        android_inline_native: json['android_inline_native'],
        android_appid: json['android_appid'],
        ios_inline_banner: json['ios_inline_banner'],
        ios_inline_native: json['ios_inline_native'],
        ios_appid: json['ios_appid'],
        estatAppId: json['estatAppId']);
    return shared;
  }
}
