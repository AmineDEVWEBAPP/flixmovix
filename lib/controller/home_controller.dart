import 'package:flixmovix/controller/web_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/service/firebase_service.dart';
import '../core/service/scrapping_service.dart';
import '../core/utils/methodes.dart';
import '../view/widgets/shared/spleach_screen.dart';

class HomeController extends GetxController {
  int pageNum = 1;

  Map<String, dynamic> itemsData = {
    'connectionStatus': true,
    'body': {'items': []}
  };
  bool homeIsLoading = false;

  String title = 'الكل';

  String? shareLink;

  Map<String, dynamic> drawerCategorysData = {};

  bool drawerIsLoading = false;

  Future reTry() async {
    homeIsLoading = true;
    update(['homeBody', 'homeSearchBar']);
    itemsData = await ScrappingService.getItems();
    homeIsLoading = false;
    update(['homeBody', 'homeSearchBar']);
  }

  Future<void> reloadCategorys() async {
    if (drawerCategorysData.isEmpty ||
        drawerCategorysData['connectionStatus'] == false ||
        drawerCategorysData['body']?['categorys'].isEmpty) {
      logger('WebView reload');
      await webViewController.reload();
    }
  }

  @override
  void onReady() async {
    await Get.showOverlay(
        opacity: 1,
        opacityColor: Colors.white,
        asyncFunction: () async {
          itemsData = await ScrappingService.getItems();
          shareLink = await FirebaseService.getShareableLink();
          update(['homeBody', 'homeSearchBar']);
        },
        loadingWidget: SpleachScreen());
    super.onReady();
  }
}
