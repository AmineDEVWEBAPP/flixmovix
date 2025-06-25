import 'dart:async';

import 'package:flixmovix/core/service/scrapping_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/theme.dart';

// ignore: must_be_immutable
class HomeSearchBar extends StatelessWidget {
  HomeSearchBar({super.key});

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  final AppTheme _appTheme = AppTheme().instance;

  bool _isIcon = true;

  final String url = AppConfig().instance.baseUrl;

  Timer? _debounce;

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
                  width: _isIcon ? Get.width * 0.78 : Get.width * 0.78,
                  height: _isIcon ? Get.height * 0.05 : Get.height * 0.05,
                  child: _isIcon
                      ? _buildSearchIcon(controller)
                      : _buildTextField(controller),
                ),
              ],
            )));
  }

  Widget _buildTextField(HomeController controller) => TextField(
        controller: _editingController,
        focusNode: _focusNode,
        onChanged: (value) async {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () async {
            controller.isLoading = true;
            controller.update(['homeBody']);
            controller.itemsData = await ScrappingService.getItems(word: value);
            controller.isLoading = false;
            controller.update(['homeBody', 'homeSearchBar']);
          });
        },
        onSubmitted: (value) {
          ScrappingService().instance.isSearch = false;
          _focusNode.unfocus();
          _isIcon = true;
          _editingController.clear();
          controller.update(['homeSearchBar']);
        },
        onTapOutside: (event) {
          ScrappingService().instance.isSearch = false;
          _focusNode.unfocus();
          _isIcon = true;
          _editingController.clear();
          controller.update(['homeSearchBar']);
        },
        cursorColor: _appTheme.theme.primaryColor,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          suffixIcon: SizedBox(
            width: Get.width * 0.25,
            child: _buildPopupMenu(controller,
                secondary: const SizedBox(),
                color: Colors.transparent,
                boxShadow: []),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: _appTheme.theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(2000)),
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: _appTheme.theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(2000)),
          hintText: 'أدخل الإسم',
          hintStyle: const TextStyle(color: Colors.black38),
          fillColor: _appTheme.theme.iconButtonTheme.style?.backgroundColor
              ?.resolve(RxSet()),
          filled: true,
        ),
      );

  Widget _buildSearchIcon(HomeController controller) => Row(children: [
        _buildPopupMenu(controller),
        Container(
            alignment: Alignment.centerLeft,
            width: Get.width * 0.36,
            child:
                Text(controller.title, style: const TextStyle(fontSize: 20))),
        SizedBox(width: Get.width * 0.05),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _isIcon = false;
            controller.update(['homeSearchBar']);
            _focusNode.requestFocus();
            ScrappingService().instance.isSearch = true;
          },
          iconSize: ((Get.width + Get.height) / 2) * 0.045,
        ),
      ]);

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
                        controller.isLoading = true;
                        controller.update(['homeBody', 'homeSearchBar']);
                        controller.pageNum = 1;
                        ScrappingService().instance.getByCollection = false;
                        ScrappingService().instance.baseUrl =
                            AppConfig().instance.baseUrl;
                        controller.itemsData =
                            await ScrappingService.getItems();

                        controller.isLoading = false;
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
    controller.isLoading = true;
    controller.update(['homeBody', 'homeSearchBar']);
    controller.pageNum = 1;
    ScrappingService().instance.getByCollection = true;
    ScrappingService().instance.baseUrl =
        controller.itemsData['body']['collections'].elementAt(index)['href'];
    controller.itemsData = await ScrappingService.getItems();
    controller.isLoading = false;
    controller.update(['homeBody', 'homeSearchBar']);
  }
}
