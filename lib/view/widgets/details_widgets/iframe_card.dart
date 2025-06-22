import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../controller/details_controller.dart';
import '../../../core/config/theme.dart';
import '../../../core/service/ads_service.dart';
import '../shared/custom_circular_progress.dart';

class IframeCard extends StatefulWidget {
  const IframeCard({super.key, required this.iframe});
  final String iframe;

  @override
  State<IframeCard> createState() => _IframeCardState();
}

class _IframeCardState extends State<IframeCard> {
  bool isLoading = true;

  final ThemeData _appTheme = AppTheme().instance.theme;

  final DetailsController _detailsController = Get.find<DetailsController>();

  late WebViewController _webViewController;

  final Stream<int> numberStream =
      Stream.periodic(const Duration(seconds: 1), (x) => x);

  late StreamSubscription<int> subscription;

  @override
  void initState() {
    subscription = numberStream.listen((event) async {
      if (event % 900 == 0 && event != 0) {
        await AdsService.showAd(
          AdsService.rewardedAdPlacementId,
          onFailed: () async {
            await AdsService.showAd(AdsService.interstitialAdPlacementId);
          },
        );
      }
    });
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          isLoading = false;
          _detailsController.update(['load']);
        },
      ))
      ..loadRequest(Uri.parse(widget.iframe));

    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      height: Get.height * 0.25,
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            WebViewWidget(controller: _webViewController),
            GetBuilder<DetailsController>(
                id: "load",
                builder: (controller) =>
                    isLoading ? _buildLoading() : const SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
        alignment: Alignment.center,
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          border: Border.all(color: _appTheme.colorScheme.secondaryContainer),
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomCircularProgress());
  }
}
