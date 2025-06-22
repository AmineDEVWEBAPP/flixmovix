import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/methodes.dart';

class AppTheme {
  static final AppTheme _instance = AppTheme();
  AppTheme get instance => _instance;
  late ThemeMode themeMode;
  late ThemeData theme;

  static init() async {
    logger('init Theme');
    _instance.themeMode = await _instance._getThemeMode();
    _instance.theme = _instance._getTheme();
  }

  Future<ThemeMode> _getThemeMode() async {
    logger('get Theme mode');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late String themeMode;
    themeMode = sharedPreferences.getString('themeMode') ?? 'system';
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  ThemeData _getTheme() {
    logger('get Theme');
    switch (themeMode) {
      case ThemeMode.light:
        return lightTheme;
      default:
        return darkTheme;
    }
  }

  Future<void> changeThemeMode(ThemeMode newThemeMode,
      {GetxController? getxController}) async {
    logger('change Theme Mode');
    if (newThemeMode == ThemeMode.system) {
      Get.isPlatformDarkMode
          ? _instance.themeMode = ThemeMode.dark
          : _instance.themeMode = ThemeMode.light;
    } else {
      _instance.themeMode = newThemeMode;
    }
    _instance.theme = _getTheme();
    Get.changeTheme(_instance.theme);
    getxController?.update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('themeMode', _instance.themeMode.name);
    Get.appUpdate();
  }

//* light Theme
  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,

    //< App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 91, 151, 255),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      shadowColor: Colors.black,
      elevation: 6,
      scrolledUnderElevation: 10,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    //>

    //< switch
    switchTheme: const SwitchThemeData(
      thumbIcon:
          WidgetStatePropertyAll(Icon(Icons.light_mode, color: Colors.white)),
      trackOutlineColor:
          WidgetStatePropertyAll(Color.fromARGB(255, 250, 182, 92)),
      thumbColor: WidgetStatePropertyAll(Colors.black),
      trackColor: WidgetStatePropertyAll(Color.fromARGB(255, 242, 242, 242)),
    ),
    //>

    //< IconButtonTheme
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
            shadowColor: WidgetStatePropertyAll(Colors.black),
            elevation: WidgetStatePropertyAll(5),
            iconColor: WidgetStatePropertyAll(Colors.black),
            backgroundColor:
                WidgetStatePropertyAll(Color.fromARGB(255, 250, 182, 92)))),
    //>

    //< TextTheme
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
    //>

    //< AppColors
    primaryColor: const Color.fromARGB(255, 91, 151, 255),
    shadowColor: const Color.fromARGB(114, 108, 101, 101),
    //>

    // colorScheme
    colorScheme: const ColorScheme.light(
      tertiary: Color.fromARGB(96, 42, 42, 42),
      secondary: Color.fromARGB(255, 250, 182, 92),
      outline: Colors.black,
      secondaryContainer: Color.fromARGB(255, 100, 100, 100),
      tertiaryContainer: Colors.white,
    ),
    //>
  );

  //* dark Theme
  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 43, 43, 43),

    //< App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 70, 119, 204),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      shadowColor: Color.fromARGB(188, 255, 255, 255),
      elevation: 6,
      scrolledUnderElevation: 10,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    //>

    //< switch
    switchTheme: const SwitchThemeData(
      thumbIcon:
          WidgetStatePropertyAll(Icon(Icons.dark_mode, color: Colors.black)),
      trackOutlineColor: WidgetStatePropertyAll(
        Colors.grey,
      ),
      thumbColor: WidgetStatePropertyAll(Colors.white),
      trackColor: WidgetStatePropertyAll(Color.fromARGB(255, 70, 70, 70)),
    ),
    //>

    //< IconButtonTheme
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
            shadowColor:
                WidgetStatePropertyAll(Color.fromARGB(208, 255, 255, 255)),
            elevation: WidgetStatePropertyAll(5),
            iconColor: WidgetStatePropertyAll(Colors.white),
            backgroundColor: WidgetStatePropertyAll(Colors.grey))),
    //>

    //< TextTheme
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
    //>

    //< AppColors
    primaryColor: const Color.fromARGB(255, 70, 119, 204),
    shadowColor: const Color.fromARGB(102, 251, 234, 234),
    //>

    // colorScheme
    colorScheme: const ColorScheme.light(
      tertiary: Color.fromARGB(95, 220, 220, 220),
      secondary: Colors.grey,
      outline: Colors.white,
      secondaryContainer: Color.fromARGB(255, 205, 205, 205),
      tertiaryContainer: Colors.black,
    ),
    //>
  );
}
