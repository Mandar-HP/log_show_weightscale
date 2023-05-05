import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wehealth/controller/storage_controller.dart';
import 'package:wehealth/models/data_model/add_user_device_data_model.dart';

import 'package:wehealth/models/data_model/user_devices_model.dart';

import 'user_devices_repository.dart';

class UserDevicesController extends GetxController {
  

  UserDevicesWrapper _userDevicesWrapper = UserDevicesWrapper();
  List<UserDeviceModel>? get userDevices {
    return _userDevicesWrapper.deviceData?.where((value) {
      return _userDevicesWrapper.deviceData
              ?.where((element) => element.devicebletype == value.devicebletype)
              .sorted((a, b) => a.insertDate!.compareTo(b.insertDate!))
              .last
              .id ==
          value.id;
    }).toList();
  }

  bool get hasBloodPressureDevice {
    bool? hasDevice = userDevices?.any((element) =>
        element.devicebletype == "3" ||
        element.devicebletype == "37" ||
        element.devicebletype == "36");
    return hasDevice ?? false;
  }

  bool get hasBloodGlucoseDevice {
    bool? hasDevice = userDevices?.any(
      (element) =>
          element.devicebletype == "15" || element.devicebletype == "35",
    );
    return hasDevice ?? false;
  }




}
