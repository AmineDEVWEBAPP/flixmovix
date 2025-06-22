import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../core/config/theme.dart';

class CustomCircularProgress extends StatelessWidget {
  CustomCircularProgress({super.key, this.size, this.color});

  final ThemeData _appTheme = AppTheme().instance.theme;

  final double? size;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SpinKitDualRing(
      color: color ?? _appTheme.colorScheme.secondary,
      size: size ?? ((Get.width + Get.height) / 2) * 0.06,
    );
  }
}
