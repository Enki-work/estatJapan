import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../model/state/AppConfigState.dart';

class AdHelper {
  static String bannerAdUnitId(BuildContext context) {
    if (Platform.isAndroid) {
      return context.read<AppConfigState>().android_inline_banner;
    } else if (Platform.isIOS) {
      return context.read<AppConfigState>().ios_inline_banner;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String nativeAdUnitId(BuildContext context) {
    if (Platform.isAndroid) {
      return context.read<AppConfigState>().android_appid;
    } else if (Platform.isIOS) {
      return context.read<AppConfigState>().ios_appid;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
