// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wehealth/screens/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/theme_controller.dart';
import 'getit_locator.dart' as getit_locator;
import 'global/constants/app_constants.dart';
import 'global/routes/routes.dart';
import 'helper/translator_helper.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

Future<AndroidDeviceInfo?> initPlatformState() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      return info;
    }
  } on PlatformException {
    print("Error: Failed to get platform version.");
  }
  return null;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final deviceInfo = await initPlatformState();

  await getit_locator.init(prefs, deviceInfo);
  Map<String, Map<String, String>> languages = await languageinit();
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({Key? key, required this.languages}) : super(key: key);


  //



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<ThemeController>(
          builder: (themeController) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'WeHealth',
              themeMode: ThemeMode.system,
              theme: themeController.themeValue ? dark : light,
              fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
                  AppConstants.languages[0].countryCode),
              routes: routes,
              initialRoute: DashboardScreen.id,
              home: child,
            );
          },
        );
      },
      child: const DashboardScreen(),
    );
  }
}
