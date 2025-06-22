import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/theme.dart';

class SwitchThemeMode extends StatefulWidget {
  const SwitchThemeMode({super.key});

  @override
  State<SwitchThemeMode> createState() => _SwitchThemeModeState();
}

class _SwitchThemeModeState extends State<SwitchThemeMode> {
  final ThemeData _appTheme = AppTheme().instance.theme;

  late String _modeDesc;

  late bool _switchValue;

  @override
  initState() {
    _modeDesc = AppTheme().instance.themeMode == ThemeMode.dark
        ? 'تفعيل الوضع النهاري'
        : 'تفعيل الوضع الليلي';
    _switchValue = AppTheme().instance.themeMode == ThemeMode.light;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(right: Get.width * 0.05),
      margin: EdgeInsets.symmetric(vertical: Get.height * 0.005),
      decoration: BoxDecoration(
          color: _appTheme.primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _appTheme.shadowColor)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.001),
        child: Row(children: [
          Text(_modeDesc, style: const TextStyle(fontSize: 20)),
          const Spacer(),
          GetBuilder<HomeController>(
              id: 'switch',
              builder: (controller) => Switch(
                    value: _switchValue,
                    onChanged: (value) async {
                      Get.defaultDialog(
                        backgroundColor: _appTheme.scaffoldBackgroundColor,
                        title:
                            'الانتقال الى الوضع ${_switchValue ? 'الليلي' : 'النهاري'}',
                        middleText:
                            'المرجوا اعادة تشغيل التطبيق للانتقال الى الوضع ${_switchValue ? 'الليلي' : 'النهاري'}',
                        textConfirm: 'تغيير',
                        textCancel: 'الغاء',
                        onCancel: () {
                          Get.back();
                        },
                        onConfirm: () async {
                          _switchValue = !_switchValue;
                          controller.update(['switch']);
                          await AppTheme().instance.changeThemeMode(
                              _switchValue ? ThemeMode.light : ThemeMode.dark);
                          exit(1);
                        },
                      );
                    },
                  )),
          SizedBox(width: Get.width * 0.01)
        ]),
      ),
    );
  }
}
