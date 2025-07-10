import 'dart:async';

import 'package:flixmovix/core/service/scrapping_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/routes.dart';
import '../../../core/config/theme.dart';

// ignore: must_be_immutable
class HomeSearchBar extends StatelessWidget {
  HomeSearchBar({super.key});

  final AppTheme _appTheme = AppTheme().instance;

  final String url = AppConfig().instance.baseUrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        id: 'homeSearchBar',
        builder: (controller) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: Get.width * 0.78,
                  height: Get.height * 0.05,
                  child: _buildSearchIcon(controller, context),
                ),
              ],
            )));
  }

  Widget _buildSearchIcon(HomeController controller, BuildContext context) {
    return Row(children: [
      _buildPopupMenu(controller),
      Spacer(),
      Container(
          alignment: Alignment.centerLeft,
          width: Get.width * 0.36,
          child: Text(controller.title, style: const TextStyle(fontSize: 20))),
      SizedBox(width: Get.width * 0.01),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          Get.toNamed(AppRoutes.search);
          controller.update(['homeSearchBar']);
          ScrappingService().instance.isSearch = true;
        },
      ),
    ]);
  }

  Widget _buildPopupMenu(HomeController controller,
      {Widget? secondary, Color? color, List<BoxShadow>? boxShadow}) {
    if (controller.itemsData.isNotEmpty) {
      if (controller.itemsData['connectionStatus']) {
        if (controller.itemsData['error']?['status'] == false) {
          return InkWell(
            onTap: () async {
              showMenu(
                  context: Get.context!,
                  position: RelativeRect.fromDirectional(
                    textDirection: TextDirection.rtl,
                    start: 70,
                    end: 90,
                    top: 0,
                    bottom: 0,
                  ),
                  color: _appTheme.theme.colorScheme.secondary,
                  useRootNavigator: true,
                  items: [
                    PopupMenuItem(
                      onTap: () async {
                        controller.title = 'الكل';
                        controller.homeIsLoading = true;
                        controller.update(['homeBody', 'homeSearchBar']);
                        controller.pageNum = 1;
                        ScrappingService().instance.getByCollection = false;
                        ScrappingService().instance.isSearch = false;
                        ScrappingService().instance.baseUrl =
                            AppConfig().instance.baseUrl;
                        controller.itemsData =
                            await ScrappingService.getItems();

                        controller.homeIsLoading = false;
                        controller.update(['homeBody', 'homeSearchBar']);
                      },
                      child: const Column(children: [Text('الكل'), Divider()]),
                    ),
                    ...List.generate(
                        controller.itemsData['body']['collections'].length,
                        (i) => PopupMenuItem(
                              onTap: () async {
                                await _getItemsByCollection(controller, i);
                              },
                              child: Column(children: [
                                Text(controller.itemsData['body']['collections']
                                    .elementAt(i)['name']),
                                const Divider()
                              ]),
                            ))
                  ]);
            },
            child: Container(
              width: Get.width * 0.2,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: color ?? _appTheme.theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: boxShadow ??
                      [
                        BoxShadow(
                            color: _appTheme.theme.shadowColor,
                            offset: const Offset(0, 1.5)),
                      ]),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: const Row(children: [
                  Text('التصنيف ', style: TextStyle(fontSize: 15)),
                  Icon(Icons.keyboard_arrow_down)
                ]),
              ),
            ),
          );
        }
      }
    }

    return secondary ?? SizedBox(width: Get.width * 0.22);
  }

  Future<void> _getItemsByCollection(
      HomeController controller, int index) async {
    controller.title =
        controller.itemsData['body']['collections'].elementAt(index)['name'];
    controller.homeIsLoading = true;
    controller.update(['homeBody', 'homeSearchBar']);
    controller.pageNum = 1;
    ScrappingService().instance.getByCollection = true;
    ScrappingService().instance.baseUrl =
        controller.itemsData['body']['collections'].elementAt(index)['href'];
    controller.itemsData = await ScrappingService.getItems();
    controller.homeIsLoading = false;
    controller.update(['homeBody', 'homeSearchBar']);
  }
}
