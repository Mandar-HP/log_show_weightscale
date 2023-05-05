import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wehealth/global/styles/text_styles.dart';
import 'package:wehealth/models/data_model/user_devices_model.dart';
import 'package:wehealth/screens/dashboard/drawer/drawer_items.dart';
import 'package:wehealth/screens/dashboard/drawer/link_device/user_device_control_screen.dart';

import 'add_new_device_list.dart';
import 'ble/flutter_blue_main.dart';

class LinkDeviceScreen extends StatefulWidget {
  const LinkDeviceScreen({Key? key}) : super(key: key);

  @override
  State<LinkDeviceScreen> createState() => _LinkDeviceScreenState();
}

class _LinkDeviceScreenState extends State<LinkDeviceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerSide(),
      appBar: AppBar(
        title: const Text("Devices"),
        //  automaticallyImplyLeading: !Platform.isIOS,
        // leading: Platform.isIOS
        // ?  IconButton(onPressed: (){
        //   Get.back();
        //   }, icon: const Icon(Icons.close),)
        // : null,
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.to(() => const FlutterBluePlusApp());
            },
            icon: const Icon(Icons.bluetooth),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {},
            icon: const Icon(Icons.message),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const SizedBox(
            height: 100,
            child: Text("No Scale"),
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              )),
              onPressed: () {
                Get.to(() => const AddNewDeviceScreen());
              },
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Add New devices".toUpperCase(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectedDeviceListTileWidget extends StatelessWidget {
  const ConnectedDeviceListTileWidget({
    Key? key,
    required this.deviceModel,
  }) : super(key: key);
  final UserDeviceModel deviceModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      onTap: () {
        Get.to(() => UserDeviceControlScreen(deviceModel: deviceModel));
      },
      leading: SizedBox(
        width: 50,
        child: Image.asset(
          deviceModel.imageLink,
        ),
      ),
      title: Text(
        deviceModel.convertedName,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyles.smallTextBoldStyle().copyWith(
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  deviceModel.devicename ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyles.normalTextBoldStyle().copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                deviceModel.devicestatus == 1 ? "Enabled" : "Disabled",
                style: TextStyles.extraSmallBoldTextStyle(),
              ),
            ],
          ),
          Text(
            deviceModel.deviceuuid ?? "",
            style: TextStyles.extraSmallBoldTextStyle(),
          ),
        ],
      ),
      trailing: Icon(
        Icons.lock,
        size: 32,
        color: Colors.grey.shade600,
      ),
    );
  }
}
