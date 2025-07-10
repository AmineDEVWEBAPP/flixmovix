import 'dart:convert';

import 'package:flixmovix/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../core/service/scrapping_service.dart';
import '../core/utils/methodes.dart';

HomeController _homeController = Get.find<HomeController>();

WebViewControllerPlus webViewController = WebViewControllerPlus()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setUserAgent(
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36')
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        logger('WebView progress');
      },
      onPageStarted: (String url) {
        logger('WebView onPageStarted');
        _homeController.drawerIsLoading = true;
        _homeController.update(['drawerLoading']);
      },
      onPageFinished: (String url) async {
        logger('WebView onPageFinished');
        if (_homeController.drawerCategorysData.isEmpty ||
            _homeController.drawerCategorysData['connectionStatus'] == false ||
            _homeController.drawerCategorysData['body']['categorys'].isEmpty) {
          await Future.delayed(const Duration(seconds: 5));
          await webViewController
              .runJavaScriptReturningResult(
                  "document.documentElement.outerHTML")
              .then((html) async {
            _homeController.drawerCategorysData =
                await ScrappingService.getCategorys(jsonDecode(html as String));
          });
          _homeController.drawerIsLoading = false;
          _homeController.update(['drawerCaregorys', 'drawerLoading']);
        }
      },
    ),
  )
  ..loadRequest(Uri.parse(ScrappingService().instance.baseUrl));
