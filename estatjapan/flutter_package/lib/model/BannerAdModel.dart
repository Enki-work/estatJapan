import 'package:flutter/cupertino.dart';
import 'package:flutter_package/Util/AdHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdModel extends ChangeNotifier {
  late BannerAd _bannerAd;

  BannerAd bannerAd() => _bannerAd;
  bool _isAdLoaded = false;
  bool isAdLoaded() => _isAdLoaded;

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isAdLoaded = true;
          print('Ad load success');
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _bannerAd.load();
  }

  void dispose() {
    _bannerAd.dispose();
    print('Ad load dispose');
    super.dispose();
  }
}
