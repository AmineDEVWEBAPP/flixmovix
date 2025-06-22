import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';
import '../../../core/utils/methodes.dart';

class ShareButton extends StatelessWidget {
  ShareButton({super.key});
  final ThemeData _appTheme = AppTheme().instance.theme;

  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(Container(
          height: Get.height * 0.12,
          alignment: const Alignment(0, -0.7),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: _appTheme.colorScheme.tertiaryContainer,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
        ));
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.005),
          height: Get.height * 0.06,
          decoration: BoxDecoration(
              color: _appTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _appTheme.shadowColor)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('مشاركة التطبيق', style: TextStyle(fontSize: 20)),
            SvgPicture.asset(
              AppAsset().svgs.share,
              height: Get.height * 0.03,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            )
          ])),
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
        "https://wa.me/?text=${Uri.encodeComponent('install flixnest for watching movie for free from this link : ${_homeController.shareLink}')}";
    if (!await launchUrl(Uri.parse(whatsappUrl))) {
      logger('ERROR : Could not launch $whatsappUrl');
    }
  }

  Future _shareOnEmail() async {
    String body =
        'flixnest is a free application for watching your best movies and seres and tv and anime \nyou can install flixnest from this link : https://${_homeController.shareLink} \n\nBest regards,\nYour Friend';
    final String emailLaunchUri =
        'mailto:?subject=${Uri.encodeComponent('flixnest')}&body=${body.replaceAll(' ', '%20')}';

    if (!await launchUrl(Uri.parse(emailLaunchUri))) {
      logger('ERROR : Could not launch $emailLaunchUri');
    }
  }
}
