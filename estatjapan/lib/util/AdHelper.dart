import 'dart:io';

import '../model/state_notifier/AppConfigNotifier.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.shared.android_inline_banner;
    } else if (Platform.isIOS) {
      return AppConfig.shared.ios_inline_banner;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.shared.android_appid;
    } else if (Platform.isIOS) {
      return AppConfig.shared.android_appid;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
