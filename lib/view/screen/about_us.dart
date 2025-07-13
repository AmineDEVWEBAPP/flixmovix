import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/config/theme.dart';

class AboutUs extends StatelessWidget {
  AboutUs({super.key});

  final ThemeData _appTheme = AppTheme().instance.theme;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('حول')),
      body: Padding(
          padding: EdgeInsetsGeometry.only(
              left: Get.width * 0.06,
              right: Get.width * 0.06,
              top: Get.width * 0.06),
          child: SingleChildScrollView(
            child: RichText(
                textAlign: TextAlign.justify,
                text:
                    TextSpan(style: _appTheme.textTheme.bodyMedium, children: [
                  TextSpan(
                    style: TextStyle(fontSize: 17),
                    text:
                        'تطبيق Flixmovix هو تطبيق هاتف لمشاهدة الافلام والمسلسلات والبرامج والانيم والمصارعة الحرة وهو تطبيق تجريبي ليس متاح على متاجر كبرى مثل playStore او appStore... فهو متاح على apkPure ان اردت الحصول على ملف apk يمكنك البحث عن التطبيق في apkPure او اتباع الرابط اسفله لتحميل الملف. وكذالك هو تطبيق مفتوح المصدر يمكنك الحصول على الكود المصدر على gitHub.',
                  ),
                  TextSpan(
                    text:
                        'ان التطبيق يعتمد على تقنية القشط للحصول على المحتوى وكل محتوى التطبيق من موقع ',
                    style: TextStyle(fontSize: 17),
                  ),
                  WidgetSpan(
                      child: InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(AppConfig().instance.baseUrl));
                    },
                    child: Text('wecima',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decorationColor: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                  )),
                  TextSpan(
                    text: '.',
                    style: TextStyle(fontSize: 17),
                  ),
                  TextSpan(
                    text: 'التطبيق مفتوح المصدر ',
                    style: TextStyle(fontSize: 17),
                  ),
                  WidgetSpan(
                      child: InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://apkpure.com/flixmovix/flix.movix.viewMedia/download'));
                    },
                    child: Text('ApkPure',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decorationColor: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                  )),
                  TextSpan(
                    text: '. ',
                    style: TextStyle(fontSize: 17),
                  ),
                  TextSpan(
                    text: 'للحصول على ملف apk ',
                    style: TextStyle(fontSize: 17),
                  ),
                  WidgetSpan(
                      child: InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://github.com/AmineDEVWEBAPP/flixmovix'));
                    },
                    child: Text('github',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decorationColor: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                  )),
                  TextSpan(
                    text: '.',
                    style: TextStyle(fontSize: 17),
                  ),
                ])),
          )));
}
