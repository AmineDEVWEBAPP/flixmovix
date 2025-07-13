import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'core/config/routes.dart';
import 'core/config/theme.dart';
import 'core/utils/methodes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      themeMode: AppTheme().instance.themeMode,
      theme: AppTheme().instance.theme,
      darkTheme: AppTheme().instance.darkTheme,
      initialRoute: AppRoutes.home.name,
      getPages: [
        AppRoutes.home,
        AppRoutes.details,
        AppRoutes.search,
        AppRoutes.note,
        AppRoutes.aboutUs,
      ],
    );
  }
}
