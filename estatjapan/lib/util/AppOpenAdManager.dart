import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AppOpenAdManager {
  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  /// Load an [AppOpenAd].
  Future<void> loadAd() async {
    const env = kReleaseMode ? 'prod' : 'dev';
    final contents = await rootBundle.loadString(
      'lib/config/$env.json',
    );
    final json = jsonDecode(contents);
    final adUnitId =
        Platform.isAndroid ? json['android_appid'] : json['ios_open_ads'];
    AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            print('$ad loaded');
          }
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print('AppOpenAd failed to load: $error');
          }
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Shows the ad, if one exists and is not already being shown.
  ///
  /// If the previously cached ad has expired, this just loads and caches a
  /// new ad.
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      if (kDebugMode) {
        print('Tried to show ad before available.');
      }
      loadAd();
      return;
    }
    if (_isShowingAd) {
      if (kDebugMode) {
        print('Tried to show ad while already showing an ad.');
      }
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      if (kDebugMode) {
        print('Maximum cache duration exceeded. Loading another ad.');
      }
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        if (kDebugMode) {
          print('$ad onAdShowedFullScreenContent');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
        }
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        if (kDebugMode) {
          print('$ad onAdDismissedFullScreenContent');
        }
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
