import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:recase/recase.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class RouteFacade {
  RouteFacade._();

  static void openInAppBrowser(String urlString) {
    final url = Uri.parse(urlString);
    launcher.canLaunchUrl(url).then((canLaunch) {
      if (!canLaunch) return;
      if (Platform.isAndroid) {
        launcher.launchUrl(url, mode: launcher.LaunchMode.externalApplication);
      } else if (Platform.isIOS) {
        ChromeSafariBrowser().open(
          url: url,
          options: ChromeSafariBrowserClassOptions(),
        );
      }
    });
  }

  static Future<T?> pushModal<T>(BuildContext context, Widget page,
      {RouteSettings? settings, bool rootNavigator = true}) {
    Route<T> route = CupertinoPageRoute<T>(
      builder: (context) => page,
      settings: settings,
      fullscreenDialog: true,
    );

    return Navigator.of(context, rootNavigator: rootNavigator).push<T>(route);
  }

  static Future<T?> push<T>(BuildContext context, Widget page,
      {RouteSettings? settings, bool rootNavigator = false}) {
    settings ??=
        RouteSettings(name: ReCase(page.runtimeType.toString()).snakeCase);
    final route =
        CupertinoPageRoute<T>(builder: (context) => page, settings: settings);

    return Navigator.of(context, rootNavigator: rootNavigator).push<T>(route);
  }

  static void popUntil(BuildContext context, String routeName,
      {bool rootNavigator = false}) {
    Navigator.of(context, rootNavigator: rootNavigator)
        .popUntil(ModalRoute.withName(routeName));
  }

  static void pop<T>(BuildContext context,
      {bool rootNavigator = false, T? result}) {
    Navigator.of(context, rootNavigator: rootNavigator).pop(result);
  }
}
