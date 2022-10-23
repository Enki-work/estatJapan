import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firebase_options.dart';

void launchURL(BuildContext context, String url) async =>
    await canLaunchUrl(Uri.parse(url))
        ? Navigator.of(context).pushNamed("WebViewPage", arguments: url)
        : throw 'Could not launch $url';
