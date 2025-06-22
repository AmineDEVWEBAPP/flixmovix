import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../utils/methodes.dart';
import 'firebase_service.dart';

class AdsService {
  AdsService._();
  static final AdsService _adsService = AdsService._();
  static String gameId =
      defaultTargetPlatform == TargetPlatform.android ? '5750801' : '5750800';

  static String interstitialAdPlacementId =
      defaultTargetPlatform == TargetPlatform.android
          ? 'Interstitial_Android'
          : 'Interstitial_IOS';

  static String rewardedAdPlacementId =
      defaultTargetPlatform == TargetPlatform.android
          ? 'Rewarded_Android'
          : 'Rewarded_IOS';

  static String bannerAdPlacementId =
      defaultTargetPlatform == TargetPlatform.android
          ? 'Banner_Android'
          : 'Banner_IOS';

  bool? _isShowAds;

  static Future init() async {
    await UnityAds.init(
      gameId: AdsService.gameId,
      onComplete: () => logger('init Unity ads'),
      onFailed: (error, message) =>
          logger('init Unity ads Failed: $error $message'),
    );

    _adsService._isShowAds = await FirebaseService.getShowAds();
  }

  static Future<void> showAd(String placementId, {Function()? onFailed}) async {
    if (_adsService._isShowAds ?? true) {
      void loadAd(String placementId) {
        UnityAds.load(
          placementId: placementId,
          onComplete: (placementId) {
            logger('Load Complete $placementId');
          },
          onFailed: (placementId, error, message) =>
              logger('Load Failed $placementId: $error $message'),
        );
      }

      loadAd(placementId);

      await UnityAds.showVideoAd(
        placementId: placementId,
        onComplete: (placementId) {
          logger('Video Ad $placementId completed');
        },
        onFailed: (placementId, error, message) async {
          logger('Video Ad $placementId failed: $error $message');
          if (onFailed != null) {
            await onFailed();
          }
        },
        onStart: (placementId) => logger('Video Ad $placementId started'),
        onClick: (placementId) => logger('Video Ad $placementId click'),
        onSkipped: (placementId) {
          logger('Video Ad $placementId skipped');
        },
      );
    }
  }

  static Widget showBannerAd() {
    if (_adsService._isShowAds ?? true) {
      return UnityBannerAd(
        placementId: AdsService.bannerAdPlacementId,
        onLoad: (placementId) => logger('Banner loaded: $placementId'),
        onClick: (placementId) => logger('Banner clicked: $placementId'),
        onShown: (placementId) => logger('Banner shown: $placementId'),
        onFailed: (placementId, error, message) =>
            logger('Banner Ad $placementId failed: $error $message'),
      );
    }
    return const SizedBox();
  }
}
