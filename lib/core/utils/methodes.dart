import 'package:firebase_core/firebase_core.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../config/app_config.dart';
import '../config/theme.dart';
import '../service/ads_service.dart';
import '../service/firebase_service.dart';
import '../service/storage_service.dart';

logger(String? message) {
  // ignore: avoid_print
  print('Logger : $message');
}

Future initServices() async {
  await Firebase.initializeApp();
  await StorageService.init();
  await AppConfig.init();
  await AppTheme.init();
  await FirebaseService.init();
  await AdsService.init();
}

Future<bool> checkConnectionStatus() async {
  InternetConnectionStatus connectionStatus =
      await InternetConnectionChecker.instance.connectionStatus;
  return connectionStatus == InternetConnectionStatus.connected ? true : false;
}
