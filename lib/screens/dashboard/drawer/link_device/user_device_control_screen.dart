import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wehealth/global/styles/text_styles.dart';
import 'package:wehealth/models/data_model/user_devices_model.dart';

import '../drawer_items.dart';


class UserDeviceControlScreen extends StatelessWidget {
  const UserDeviceControlScreen({Key? key, required this.deviceModel})
      : super(key: key);
  final UserDeviceModel deviceModel;

  @override
  Widget build(BuildContext context) {
    return IosScaffoldWrapper(
      title: "Devices",
      appBarColor: Colors.blue,
      body: Column(
        children: [
          SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: Image.asset(deviceModel.imageLink),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        deviceModel.convertedName,
                        style: TextStyles.extraLargeTextBoldStyle(),
                      ),
                      Text(
                        deviceModel.deviceuuid ?? "",
                        style: TextStyles.normalTextBoldStyle().copyWith(
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Last Pairing Date",
            style: TextStyles.extraLargeTextBoldStyle().copyWith(
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat("d MMMM y, h:mm a").format(
              stringDateWithTZ.parse(deviceModel.insertionDateTime ?? ""),
            ),
            style: TextStyles.normalTextBoldStyle().copyWith(
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ...getControlWidgets(deviceModel.devicebletype ?? "0"),
        ],
      ),
    );
  }

  List<Widget> getControlWidgets(String deviceId) {
    if (deviceId == "30") {
      return [
        TileButton(
          onPress: () async {
          
           
            
          },
          title: "Sync Data",
          icon: Icons.sync,
        ),
        TileButton(
          onPress: () {
           
          },
          title: "Device Settings",
          icon: Icons.settings,
        ),
        TileButton(
          onPress: () async {
          
          },
          title: "Remove Device",
          icon: Icons.cancel,
        ),
      ];
    }
    return [
      TileButton(
        onPress: () {},
        title: "Enable Group Reading",
        icon: Icons.group,
      ),
      TileButton(
        onPress: () async {
          
        },
        title: "Remove Device",
        icon: Icons.cancel,
      ),
    ];
  }
}

class TileButton extends StatelessWidget {
  const TileButton({
    Key? key,
    required this.onPress,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final VoidCallback onPress;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        ListTile(
          minVerticalPadding: 16,
          onTap: onPress,
          leading: Icon(
            icon,
            size: 40,
            color: Colors.black,
          ),
          title: Text(
            title,
            style: TextStyles.smallTextBoldStyle(),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}
DateFormat stringDateWithTZ = DateFormat("yyyy-MM-ddTHH:mm:ss.S");

class IosScaffoldWrapper extends StatelessWidget {
  const IosScaffoldWrapper({
    Key? key,
    required this.title,
    required this.appBarColor,
    required this.body,
  }) : super(key: key);
  final String title;
  final Color appBarColor;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          title,
          style: TextStyles.smallTextStyle(),
        ),
        automaticallyImplyLeading: !Platform.isIOS,
        leading: Platform.isIOS
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close),
              )
            : null,
      
      ),
      drawer: Platform.isAndroid ? const DrawerSide() : null,
      body: Container(
        margin: Platform.isIOS ? const EdgeInsets.only(bottom: 20) : null,
        child: body,
      ),
    );
  }
}