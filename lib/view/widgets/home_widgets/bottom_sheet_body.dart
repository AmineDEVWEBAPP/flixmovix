import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';
import '../../../core/utils/methodes.dart';

class BottomSheetBody extends StatelessWidget {
  BottomSheetBody({super.key});
  final ThemeData _appTheme = AppTheme().instance.theme;

  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.12,
      alignment: const Alignment(0, -0.7),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: _appTheme.colorScheme.tertiaryContainer,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _buildShareItem(
            onTap: () async {
              await _copy();
            },
            imageSr: AppAsset().images.copy),
        _buildShareItem(
            onTap: () async {
              await _shareOnEmail();
            },
            imageSr: AppAsset().images.gmail),
        _buildShareItem(
            onTap: () async {
              await _shareOnWhatsApp();
            },
            imageSr: AppAsset().images.whatsapp),
      ]),
    );
  }

  Widget _buildShareItem(
          {required Function() onTap, required String imageSr}) =>
      Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTap,
            child:
                SizedBox(width: Get.width * 0.13, child: Image.asset(imageSr)),
          ),
        ),
      );

  Future _copy() async {
    await Clipboard.setData(
            ClipboardData(text: _homeController.shareLink ?? ''))
        .then((_) {
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: _appTheme.colorScheme.tertiaryContainer,
        messageText: const Text('link copied',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        borderRadius: 1000,
        maxWidth: Get.width * 0.5,
      ));
    });
  }

  Future _shareOnWhatsApp() async {
    final whatsappUrl =
        "https://wa.me/?text=${Uri.encodeComponent('تحميل Flixmovix لمشاهدة الافلام والبرامج والانيم وغيرها: ${_homeController.shareLink}')}";
    if (!await launchUrl(Uri.parse(whatsappUrl))) {
      logger('ERROR : Could not launch $whatsappUrl');
    }
  }

  Future _shareOnEmail() async {
    final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'example@example.com',
        query:
            Uri.encodeFull('subject=Hello&body=${_homeController.shareLink}'));

    if (!await launchUrl(emailUri)) {
      logger('ERROR : Could not launch ${emailUri.path}');
    }
  }
}
