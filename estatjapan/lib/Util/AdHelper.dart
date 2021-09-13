import 'dart:io';

import 'AppConfig.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.shared.android_inline_banner;
    } else if (Platform.isIOS) {
      return AppConfig.shared.ios_inline_banner;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.shared.android_appid;
    } else if (Platform.isIOS) {
      return AppConfig.shared.android_appid;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
