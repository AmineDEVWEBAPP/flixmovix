import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../core/config/routes.dart';
import '../../core/config/theme.dart';
import '../../core/service/ads_service.dart';
import '../../core/service/scrapping_service.dart';
import '../../data/models/item_model.dart';
import '../widgets/home_widgets/grid_view_loading.dart';
import '../widgets/home_widgets/home_drawer.dart';
import '../widgets/shared/custom_circular_progress.dart';
import '../widgets/shared/error_widget.dart';
import '../widgets/home_widgets/home_search_bar.dart';
import '../widgets/shared/item_card.dart';
import '../widgets/shared/no_wifi_widget.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final ThemeData _appTheme = AppTheme().instance.theme;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () async {
                scaffoldState.currentState?.openDrawer();
                await AdsService.showAd(AdsService.interstitialAdPlacementId);
              }),
          automaticallyImplyLeading: false,
          title: HomeSearchBar(),
        ),
        drawer: HomeDrawer(),
        backgroundColor: _appTheme.scaffoldBackgroundColor,
        body: GetBuilder<HomeController>(
            id: 'homeBody',
            builder: (controller) => Stack(children: [
                  _buildBody(controller),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AdsService.showBannerAd(),
                  )
                ])));
  }

  Widget _buildBody(HomeController controller) {
    if (controller.isLoading) {
      return Center(child: CustomCircularProgress());
    } else if (controller.itemsData.isEmpty) {
      return const SizedBox();
    } else if (controller.itemsData['connectionStatus'] == false) {
      return NoWifiWidget(onTapRetry: () async {
        await controller.reTry();
      });
    } else if (controller.itemsData['error']['status'] == true) {
      return ErrorBodyWidget(
          statusCode: controller.itemsData['statusCode'],
          onTapRetry: () async {
            await controller.reTry();
          });
    } else {
      return RefreshIndicator(
          onRefresh: () async {
            controller.itemsData = await ScrappingService.getItems();
            controller.update(['homeBody', 'homeSearchBar']);
          },
          backgroundColor: _appTheme.primaryColor,
          color: _appTheme.colorScheme.secondary,
          child: GridViewLoading.builder(
            onEnd: () async {
              Map<String, dynamic> newItemsData =
                  await ScrappingService.getItems(
                newItems: true,
                pageNum: controller.pageNum + 1,
              );
              if (newItemsData['connectionStatus'] == false) {
                _internitSnackBar();
              } else if (newItemsData['error']['status']) {
                _errorSnackBar(newItemsData['statusCode']);
              } else {
                controller.itemsData['body']['items']
                    .addAll(newItemsData['body']['items']);
                controller.update(['homeBody']);
                controller.pageNum++;
              }
            },
            itemBuilder: (i) {
              return ItemCard(
                onTap: () async {
                  await AdsService.showAd(AdsService.interstitialAdPlacementId);
                  Get.toNamed(AppRoutes.details, arguments: {
                    'href': controller.itemsData['body']['items']
                        .elementAt(i)['href'],
                    'title': controller.itemsData['body']['items']
                        .elementAt(i)['title']
                  });
                },
                model: ItemModel(
                  title: controller.itemsData['body']['items']
                      .elementAt(i)['title'],
                  imageUrl: controller.itemsData['body']['items']
                      .elementAt(i)['imageUrl'],
                  episode: controller.itemsData['body']['items']
                      .elementAt(i)['episode'],
                  year: controller.itemsData['body']['items']
                      .elementAt(i)['year'],
                  href: controller.itemsData['body']['items']
                      .elementAt(i)['href'],
                  isFilm: controller.itemsData['body']['items']
                      .elementAt(i)['isFilm'],
                ),
              );
            },
            itemCount: controller.itemsData['body']?['items']?.length,
          ));
    }
  }

  SnackbarController _internitSnackBar() => Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 3),
        message: 'تحقق من الانترنت وحاول مرة اخرة',
        borderRadius: 10,
        icon: Icon(Icons.wifi_off,
            color: _appTheme.colorScheme.tertiaryContainer),
      ));

  SnackbarController _errorSnackBar(int statusCode) =>
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 3),
        message: 'حدث خطأ : $statusCode',
        borderRadius: 10,
        icon: Icon(Icons.error_outline,
            color: _appTheme.colorScheme.tertiaryContainer),
      ));
}
