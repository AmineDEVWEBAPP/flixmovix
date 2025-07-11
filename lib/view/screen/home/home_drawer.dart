import 'dart:io';

import 'package:flixmovix/view/widgets/shared/custom_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/assets.dart';
import '../../../core/config/routes.dart';
import '../../../core/config/theme.dart';
import '../../../core/service/scrapping_service.dart';
import '../../widgets/home_widgets/bottom_sheet_body.dart';

// ignore: must_be_immutable
class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  final ThemeData _appTheme = AppTheme().instance.theme;

  late bool _switchThemeValue = true;

  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.7,
      height: Get.height,
      decoration: BoxDecoration(
          color: _appTheme.colorScheme.secondary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: Get.height * 0.03),
          _buildHeader(_homeController),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
              child: Divider()),
          _buildBody(_homeController),
        ]),
      ),
    );
  }

  Widget _buildHeader(HomeController controller) => Container(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
      height: Get.height * 0.1,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Image.asset(AppAsset().images.logo),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flixmovix',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('شاهد افلامك المفضلة', style: TextStyle()),
          ],
        )
      ]));

  Widget _buildBody(HomeController controller) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
        child: SizedBox(
          height: Get.height * 0.85,
          child: Column(children: [
            _buildCategorysList(),
            _buildButton(
                AppTheme().instance.themeMode == ThemeMode.dark
                    ? 'تفعيل الوضع النهاري'
                    : 'تفعيل الوضع الليلي',
                suffix: GetBuilder<HomeController>(
                    id: 'switchTheme',
                    initState: (state) {
                      _switchThemeValue =
                          AppTheme().instance.themeMode == ThemeMode.light;
                    },
                    builder: (controller) => Switch(
                          value: _switchThemeValue,
                          onChanged: (value) async {
                            await Get.defaultDialog(
                              backgroundColor:
                                  _appTheme.scaffoldBackgroundColor,
                              title:
                                  'الانتقال الى الوضع ${_switchThemeValue ? 'الليلي' : 'النهاري'}',
                              middleText:
                                  'المرجوا اعادة تشغيل التطبيق للانتقال الى الوضع ${_switchThemeValue ? 'الليلي' : 'النهاري'}',
                              textConfirm: 'تغيير',
                              textCancel: 'الغاء',
                              onCancel: () {
                                Get.back();
                              },
                              onConfirm: () async {
                                _switchThemeValue = !_switchThemeValue;
                                controller.update(['switchTheme']);
                                await AppTheme().instance.changeThemeMode(
                                    _switchThemeValue
                                        ? ThemeMode.light
                                        : ThemeMode.dark);
                                exit(1);
                              },
                            );
                          },
                        ))),
            _buildButton('مشاركة التطبيق', suffix: Icon(Icons.share),
                onTap: () async {
              await Get.bottomSheet(BottomSheetBody());
            }),
            _buildButton('تدوين ملاحضة', suffix: Icon(Icons.note), onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.note);
            }),
            _buildButton('حول', suffix: Icon(Icons.info)),
            SizedBox(height: Get.height * 0.02),
            GetBuilder<HomeController>(
                id: 'drawerLoading',
                initState: (state) async {
                  await _homeController.reloadCategorys();
                },
                builder: (controller) => controller.drawerIsLoading
                    ? CustomCircularProgress(color: _appTheme.primaryColor)
                    : SizedBox()),
            Spacer(),
            const Text.rich(TextSpan(children: [
              TextSpan(text: 'Created by '),
              TextSpan(
                  text: 'AmineDEVWEBAPP',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontStyle: FontStyle.italic))
            ])),
          ]),
        ),
      );

  Widget _buildButton(String text, {void Function()? onTap, Widget? suffix}) =>
      InkWell(
        onTap: onTap,
        child: Container(
          height: Get.height * 0.05,
          padding: EdgeInsets.only(right: Get.width * 0.05),
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.005),
          decoration: BoxDecoration(
              color: _appTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _appTheme.shadowColor),
              boxShadow: [
                BoxShadow(
                  color: AppTheme().instance.theme.shadowColor,
                  blurRadius: 2,
                  spreadRadius: 2,
                )
              ]),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text, style: const TextStyle(fontSize: 17)),
                  Row(children: [
                    suffix ?? SizedBox(),
                    SizedBox(width: Get.width * 0.02)
                  ]),
                ],
              )),
        ),
      );

  Widget _buildCategorysList() {
    return GetBuilder<HomeController>(
        id: 'drawerCaregorys',
        builder: (controller) => Column(children: [
              ...List.generate(
                  _homeController
                          .drawerCategorysData['body']?['categorys'].length ??
                      0,
                  (i) => _buildButton(
                          _homeController.drawerCategorysData['body']
                                  ['categorys']
                              .elementAt(i)['name'],
                          suffix: Icon(Icons.category), onTap: () async {
                        Get.back();
                        ScrappingService().instance.baseUrl = _homeController
                            .drawerCategorysData['body']['categorys']
                            .elementAt(i)['href'];
                        await _homeController.reTry();
                      })),
            ]));
  }
}
