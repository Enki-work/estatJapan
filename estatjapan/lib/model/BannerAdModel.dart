import 'package:estatjapan/Util/AdHelper.dart';
import 'package:estatjapan/Util/AppConfig.dart';
import 'package:estatjapan/model/pigeonModel/PurchaseModelApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdModel extends ChangeNotifier {
  late BannerAd _bannerAd;

  BannerAd bannerAd() => _bannerAd;
  bool _isAdLoaded = false;
  bool isAdLoaded() => _isAdLoaded;
  bool _isPurchase = false;
  bool isPurchase() => _isPurchase;

  void loadBannerAd() {
    if (AppConfig.shared.purchaseModel == null) {
      HostPurchaseModelApi().getPurchaseModel().then((value) {
        AppConfig.shared.purchaseModel = value;
        loadBannerAd();
      });
      return;
    }
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!_isPurchase) {
            _isAdLoaded = true;
            notifyListeners();
          }
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
        },
      ),
    );
    if (AppConfig.shared.purchaseModel?.isPurchase == true) {
      _isPurchase = true;
      _isAdLoaded = false;
      _bannerAd.dispose();
      notifyListeners();
      return;
    }

    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
