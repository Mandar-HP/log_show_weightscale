import 'package:device_info_plus/device_info_plus.dart';
import 'package:wehealth/controller/language_controller.dart';
import 'package:wehealth/controller/storage_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/theme_controller.dart';
import 'helper/translator_helper.dart';

Future init(SharedPreferences prefs, AndroidDeviceInfo? deviceInfo) async {
  await languageinit();
   Get.put(ThemeController());

  StorageController.initialize(pref: prefs, enableLog: true);

  // Get.lazyPut(() => ThemeController());
  // Get.lazyPut(() => LocalizationController(prefs: prefs));
  Get.lazyPut(() => LanguageController(prefs: prefs));
  Get.lazyPut(() => StorageController(prefs: prefs, deviceInfo: deviceInfo, enableLog: true));


}
