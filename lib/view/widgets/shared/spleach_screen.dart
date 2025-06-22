import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';
import 'custom_circular_progress.dart';

class SpleachScreen extends StatelessWidget {
  SpleachScreen({super.key});

  final ThemeData _appTheme = AppTheme().instance.theme;

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            _appTheme.primaryColor.withAlpha(150),
            _appTheme.primaryColor,
          ])),
      child: Center(
        child: SizedBox(
            width: Get.width * 0.3,
            height: Get.height * 0.1425,
            child: Stack(
              children: [
                ClipRRect(
                    child: Image.asset(
                  AppAsset().images.logo,
                )),
                CustomCircularProgress(
                    size: ((Get.width + Get.height) / 2) * 0.1),
              ],
            )),
      ));
}
