import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';

class ErrorBodyWidget extends StatelessWidget {
  ErrorBodyWidget({super.key, required this.statusCode, this.onTapRetry});
  final AppTheme _appTheme = AppTheme().instance;
  final int statusCode;
  final void Function()? onTapRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: Get.height * 0.22,
          child: Column(
            children: [
              SvgPicture.asset(
                AppAsset().svgs.error,
                width: Get.width * 0.3,
                colorFilter: ColorFilter.mode(
                    _appTheme.theme.colorScheme.secondaryContainer,
                    BlendMode.srcIn),
              ),
              Text('خطأ : $statusCode',
                  style: const TextStyle(
                    fontSize: 20,
                  )),
              InkWell(
                  onTap: onTapRetry,
                  child: Text('اعادة المحاولة',
                      style: TextStyle(
                        color: _appTheme.theme.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      )))
            ],
          )),
    );
  }
}
