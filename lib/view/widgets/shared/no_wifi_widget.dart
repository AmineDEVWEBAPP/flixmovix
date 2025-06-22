import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';

class NoWifiWidget extends StatelessWidget {
  NoWifiWidget({super.key, this.onTapRetry});
  final AppTheme _appTheme = AppTheme().instance;
  final void Function()? onTapRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: Get.height * 0.22,
          child: Column(
            children: [
              SvgPicture.asset(
                AppAsset().svgs.noWifi,
                width: Get.width * 0.3,
                colorFilter: ColorFilter.mode(
                    _appTheme.theme.colorScheme.secondaryContainer,
                    BlendMode.srcIn),
              ),
              const Text('لا يتوفر اتصال بالانترنت',
                  style: TextStyle(
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
