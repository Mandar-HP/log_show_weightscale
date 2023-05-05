import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:wehealth/global/styles/text_styles.dart';
import 'package:wehealth/screens/dashboard/drawer/drawer_items.dart';
import 'package:wehealth/screens/dashboard/drawer/link_device/new_device_screen.dart';

class AddNewDeviceScreen extends StatefulWidget {
  const AddNewDeviceScreen({Key? key}) : super(key: key);

  @override
  State<AddNewDeviceScreen> createState() => __AddNewDeviceScreenState();
}

class __AddNewDeviceScreenState extends State<AddNewDeviceScreen> {
  List<String> itemsList = [
    "Weighing Scale",
  ];
  List<String> imageList = [
    "Weighing Scale",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Platform.isAndroid ? const DrawerSide() : null,
      appBar: AppBar(
        title: const Text("Devices"),
        automaticallyImplyLeading: !Platform.isIOS,
        leading: Platform.isIOS
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close),
              )
            : null,
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              Get.to(() => const TestingConnectedDevicesScreen());
            },
            icon: const Icon(
              Icons.bluetooth_connected,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
             
            },
            icon: const Icon(Icons.message),
          ),
        ],
      ),
      body: ListView(
        children: [
          AddDeviceItemWidget(
            id: "6",
            title: "Weighing Scale",
            imgLink: "assets/images/mnu_bweight_l.webp",
            color: Colors.blue,
            onTap: () {
              Get.to(() => const NewDeviceScreen(id: "6"));
            },
            subtitle: "Add Device",
          ),
        ],
      ),
    );
  }
}

class AddDeviceItemWidget extends StatelessWidget {
  const AddDeviceItemWidget({
    Key? key,
    required this.id,
    required this.title,
    required this.imgLink,
    required this.onTap,
    this.subtitle,
    this.color,
  }) : super(key: key);
  final String id;
  final String imgLink;
  final String title;
  final String? subtitle;
  final Color? color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      horizontalTitleGap: 18,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 0.5,
          color: Colors.grey,
        ),
      ),
      leading: Image.asset(
        imgLink,
        color: color,
      ),
      subtitle: Text(subtitle ?? ""),
      title: Text(
        title,
        style: TextStyles.normalTextBoldStyle().copyWith(
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}


class TestingConnectedDevicesScreen extends StatefulWidget {
  const TestingConnectedDevicesScreen({Key? key}) : super(key: key);

  @override
  State<TestingConnectedDevicesScreen> createState() =>
      _TestingConnectedDevicesScreenState();
}

class _TestingConnectedDevicesScreenState
    extends State<TestingConnectedDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
      ),
      body: FutureBuilder<List<BluetoothDevice>>(
          initialData: const [],
          future: FlutterBluePlus.instance.connectedDevices,
          builder: (context, snapshot) {
            final dataList = snapshot.data!;
            return dataList.isEmpty
                ? const Text("No connected devices!")
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: dataList
                        .map(
                          (result) => ListTile(
                            title: Text(result.name),
                            subtitle: Text(
                              result.id.toString(),
                            ),
                            onTap: () {
                              Get.to(
                                () => DeviceServicesScreen(device: result),
                              );
                            },
                          ),
                        )
                        .toList(),
                  );
          }),
    );
  }
}


class DeviceServicesScreen extends StatelessWidget {
  const DeviceServicesScreen({Key? key, required this.device})
      : super(key: key);
  static const deviceKey = "0000180a-0000-1000-8000-00805f9b34fb";
  final BluetoothDevice device;
  @override
  Widget build(BuildContext context) {
    device.discoverServices();

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<BluetoothService>>(
        initialData: const [],
        stream: device.services,
        builder: (context, snapshot) => ListView.builder(
          itemBuilder: (context, index) {
            final data = snapshot.data![index];
            return ListTile(
              title: Text(
                data.uuid.toString(),
              ),
              //subtitle: Text(data.deviceId.toString()),
              onTap: () {
                log(data.toString());
                Get.to(() => ServiceCharecteristicsScreen(service: data));
              },
            );
          },
          itemCount: snapshot.data!.length,
        ),
      ),
    );
  }
}


class ServiceCharecteristicsScreen extends StatefulWidget {
  const ServiceCharecteristicsScreen({Key? key, required this.service})
      : super(key: key);

  final BluetoothService service;

  @override
  State<ServiceCharecteristicsScreen> createState() =>
      _ServiceCharecteristicsScreenState();
}

class _ServiceCharecteristicsScreenState
    extends State<ServiceCharecteristicsScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }
initialize() async {
for (var element in widget.service.characteristics) {
await element.setNotifyValue(true);
element.value.listen(callBack);
}
}

  callBack(List<int> value) {
    log('##Data Readed! => $value');
  }

  @override
  void dispose() {
    widget.service.characteristics.forEach((element) {
      element.setNotifyValue(false);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.service.characteristics.length,
        itemBuilder: (context, index) {
          final char = widget.service.characteristics[index];
          return ListTile(
            title: Text(
              char.deviceId.toString(),
            ),
            onTap: () async {
              final res = await char.read();
              log(res.toString());
              String data = '';
              res.forEach((element) {
                data = data + element.toRadixString(16);
              });
              log("Converted data => $data || length => ${data.length}");
            },
          );
        },
      ),
    );
  }
}
