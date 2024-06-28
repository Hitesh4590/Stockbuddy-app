import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  late BannerAd _bannerAd;
  late InterstitialAd _interstitialAd;
  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdLoaded = false;

  factory AdService() {
    return _instance;
  }

  AdService._internal() {
    _initializeBannerAd();
    _initializeInterstitialAd();
  }

  void _initializeBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isBannerAdLoaded = true;
          print('Banner ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _isBannerAdLoaded = false;
          ad.dispose();
          print('Banner ad failed to load: $error');
        },
        onAdOpened: (Ad ad) => print('Banner ad opened.'),
        onAdClosed: (Ad ad) => print('Banner ad closed.'),
      ),
    )..load();
  }

  void _initializeInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          print('Interstitial ad loaded.');
          _interstitialAd.setImmersiveMode(true);
          _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) =>
                print('Interstitial ad showed.'),
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _isInterstitialAdLoaded = false;
              _initializeInterstitialAd(); // Load a new ad
              print('Interstitial ad dismissed.');
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              ad.dispose();
              _isInterstitialAdLoaded = false;
              _initializeInterstitialAd(); // Load a new ad
              print('Interstitial ad failed to show: $error');
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdLoaded = false;
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  Widget getBannerAdWidget() {
    if (_isBannerAdLoaded) {
      return Container(
        child: AdWidget(ad: _bannerAd),
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
        alignment: Alignment.center,
      );
    } else {
      return SizedBox.shrink();
    }
  }

  void showInterstitialAd() {
    if (_isInterstitialAdLoaded) {
      _interstitialAd.show();
    } else {
      print('Interstitial ad is not loaded yet.');
    }
  }

  void disposeBannerAd() {
    _bannerAd.dispose();
  }

  void disposeInterstitialAd() {
    _interstitialAd.dispose();
  }
}
