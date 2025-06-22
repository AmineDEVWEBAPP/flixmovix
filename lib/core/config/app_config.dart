import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/methodes.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig();
  AppConfig get instance => _instance;

  late final String baseUrl;

  static Future<void> init() async {
    await _instance.loading();
  }

  Future<void> loading() async {
    await dotenv.load(fileName: '.env');
    baseUrl = dotenv.env['BASEURL'] ?? '';
    logger('baseUrl = $baseUrl');
  }
}
