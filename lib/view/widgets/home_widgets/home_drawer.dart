import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';
import '../../../core/service/scrapping_service.dart';
import '../shared/custom_circular_progress.dart';
import '../shared/error_widget.dart';
import '../shared/no_wifi_widget.dart';
import 'share_button.dart';
import 'switch_theme_mode.dart';

// ignore: must_be_immutable
class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  bool isLoading = false;

  InAppWebViewController? _webViewController;

  final HomeController _homeController = Get.find<HomeController>();

  final ThemeData _appTheme = AppTheme().instance.theme;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        dispose: (state) {
          isLoading = false;
          _webViewController = null;
          _webViewController?.dispose();
        },
        builder: (controller) => Container(
              width: Get.width * 0.7,
              height: Get.height,
              decoration: BoxDecoration(
                  color: _appTheme.colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: Get.height * 0.99,
                    child: Column(children: [
                      _buildHeader(controller),
                      SizedBox(height: Get.height * 0.1),
                      const SwitchThemeMode(),
                      ShareButton(),
                      GetBuilder<HomeController>(
                        id: 'drawerBody',
                        builder: (bodyController) => isLoading
                            ? _loadingWidget()
                            : _buildBody(bodyController),
                      ),
                      const Spacer(),
                      const Text.rich(TextSpan(children: [
                        TextSpan(text: 'Developed by '),
                        TextSpan(
                            text: 'Amine Khadir',
                            style: TextStyle(fontWeight: FontWeight.w700))
                      ])),
                    ]),
                  )),
            ));
  }

  Widget _buildHeader(HomeController controller) => SizedBox(
        width: Get.width,
        height: Get.height * 0.1,
        child: Stack(
          children: [
            _buildWebView(controller),
            Container(
                alignment: Alignment.center,
                width: Get.width,
                height: Get.height * 0.1,
                padding: EdgeInsets.only(top: Get.height * 0.01),
                decoration: BoxDecoration(
                    color: _appTheme.colorScheme.secondary,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(15))),
                child: Image.asset(AppAsset().images.logo))
          ],
        ),
      );

  Widget _buildBody(HomeController controller) {
    return _homeController.drawerCategorysData?['connectionStatus'] == false
        ? Expanded(
            child: NoWifiWidget(
              onTapRetry: () async {
                isLoading = true;
                controller.update(['drawerBody']);
                await _webViewController?.reload();
                isLoading = false;
                controller.update(['drawerBody']);
              },
            ),
          )
        : _homeController.drawerCategorysData?['error']?['status'] == true
            ? Expanded(
                child: ErrorBodyWidget(
                onTapRetry: () async {
                  isLoading = true;
                  controller.update(['drawerBody']);
                  await _webViewController?.reload();
                  isLoading = false;
                  controller.update(['drawerBody']);
                },
                statusCode: _homeController.drawerCategorysData?['statusCode'],
              ))
            : Column(children: [
                ...List.generate(
                    _homeController.drawerCategorysData?['body']?['categorys']
                            .length ??
                        0,
                    (i) => _buildButtonList(
                        _homeController.drawerCategorysData?['body']
                                ['categorys']
                            .elementAt(i),
                        controller)),
              ]);
  }

  Widget _buildButtonList(
          Map<String, dynamic> items, HomeController homeController) =>
      InkWell(
        onTap: () async {
          Get.back();
          ScrappingService().instance.baseUrl = items['href'];
          await homeController.reTry();
        },
        child: Container(
          width: Get.width,
          padding: EdgeInsets.only(right: Get.width * 0.05),
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.005),
          decoration: BoxDecoration(
              color: _appTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _appTheme.shadowColor)),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
              child: Text(items['name'], style: const TextStyle(fontSize: 20))),
        ),
      );

  Widget _buildWebView(HomeController homeController) => InAppWebView(
        initialUrlRequest:
            URLRequest(url: WebUri(ScrappingService().instance.baseUrl)),
        initialSettings: InAppWebViewSettings(
          preferredContentMode: UserPreferredContentMode.DESKTOP,
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
          javaScriptEnabled: true,
          useOnLoadResource: true,
          loadsImagesAutomatically: false,
        ),
        onWebViewCreated: (controller) async {
          _webViewController = controller;
          await controller.evaluateJavascript(source: """
  document.querySelector('meta[name="viewport"]').setAttribute('content', 'width=1280,height=280 initial-scale=1.0');
""");
        },
        onLoadStart: (controller, url) {
          if (_homeController.drawerCategorysData == null) {
            isLoading = true;
            homeController.update(['drawerBody']);
          }
        },
        onLoadStop: (controller, url) async {
          if (_homeController.drawerCategorysData == null) {
            String? html = await controller.getHtml();
            _homeController.drawerCategorysData =
                await ScrappingService.getCategorys(html);
            isLoading = false;
            homeController.update(['drawerBody']);
          }
        },
        onReceivedError: (controller, request, error) async {
          String? html = await controller.getHtml();
          _homeController.drawerCategorysData =
              await ScrappingService.getCategorys(html,
                  hasError: true, error: error);
          isLoading = false;
          homeController.update(['drawerBody']);
        },
      );

  Widget _loadingWidget() => Expanded(
        child: Container(
          alignment: Alignment.center,
          child: CustomCircularProgress(color: _appTheme.primaryColor),
        ),
      );
}
