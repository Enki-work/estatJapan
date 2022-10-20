import 'package:estatjapan/model/state/AppConfigState.dart';
import 'package:estatjapan/util/AdHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class BannerAdModel extends ChangeNotifier {
  late BannerAd? _bannerAd;

  BannerAd bannerAd() => _bannerAd!;
  bool _isAdLoaded = false;
  bool isAdLoaded() => _isAdLoaded;
  bool _isPurchase = false;
  bool isPurchase() => _isPurchase;

  Future<void> loadBannerAd(BuildContext context) async {
    // if (context.read<AppConfigState>().purchaseModel == null) {
    //   final purchaseModel = await HostPurchaseModelApi().getPurchaseModel();
    //   context.read<AppConfigNotifier>().purchaseModel = purchaseModel;
    //   loadBannerAd(context);
    //   return;
    // }
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId(context),
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
    if (context.read<AppConfigState>().purchaseModel.isPurchase == true) {
      _isPurchase = true;
      _isAdLoaded = false;
      _bannerAd?.dispose();
      notifyListeners();
      return;
    }

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
