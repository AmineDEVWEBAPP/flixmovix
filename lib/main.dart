import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'core/bindings/details_bindings.dart';
import 'core/bindings/home_bindings.dart';
import 'core/config/routes.dart';
import 'core/config/theme.dart';
import 'core/utils/methodes.dart';
import 'view/screen/details/details.dart';
import 'view/screen/home.dart';

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
      initialRoute: AppRoutes.home,
      getPages: [
        GetPage(
            name: AppRoutes.home, page: () => Home(), binding: HomeBindings()),
        GetPage(
            name: AppRoutes.details,
            page: () => Details(),
            binding: DetailsBindings()),
      ],
    );
  }
}
