import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wehealth/global/methods/methods.dart';
import 'package:wehealth/global/styles/text_styles.dart';
import 'package:wehealth/screens/dashboard/drawer/drawer_items.dart';
import 'package:wehealth/screens/dashboard/drawer/link_device/widgets.dart';
import '../../../../controller/user_devices_controller/user_devices_controller.dart';


class NewDeviceScreen extends StatefulWidget {
  final String? id;
  const NewDeviceScreen({Key? key, this.id}) : super(key: key);

  @override
  State<NewDeviceScreen> createState() => _NewDeviceScreenState();
}

class _NewDeviceScreenState extends State<NewDeviceScreen> {
  String? id;
  List<String> scannedDevices = [];
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
     
      ),
      body: scannedDevices.isNotEmpty
          ? ListView.builder(
              itemCount: scannedDevices.length,
              itemBuilder: (context, index) => const ListTile(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    if (widget.id == "1")
                      InkWell(
                        onTap: () async {
                         
                        },
                        child: Row(
                          children: [
                            Image.asset("assets/images/googlefit.webp",
                                width: 50),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Google Fit",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                Text("Sync Data From Google Fit"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (widget.id == "2")
                      Column(
                        children: [
                          Image.asset("assets/images/pairdevice1.png"),
                          Image.asset("assets/images/second.png"),
                        ],
                      ),
                    const SizedBox(height: 8),
                    if (widget.id == "3")
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Please press and hold Microlife's \"Power On\" button until the screen show \"CL Pr\".",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (widget.id == "4") const Text("Comming soon..."),
                    if (widget.id == "5")
                      const Text(
                          "Please press Start button of Activity Tracker"),
                    if (widget.id == "6") const WeightScaleWidget(),
                    if (widget.id == "7")
                      const Text("Please press start button of bp device"),
                    if (widget.id == "8") const Text("Blood Glucose"),
                    if (widget.id == "9")
                      const Text("Please press start button of blood oxymeter"),
                    if (widget.id == "10")
                      const Text(
                          "Please press start button of nutrition scale"),
                    if (widget.id == "11")
                      const Text(
                          "Please press start button of body temperature device"),
                  ],
                ),
              ),
            ),
    );
  }
}

class PairDialogue extends StatelessWidget {
  const PairDialogue({
    Key? key,
    required this.scanResult,
    required this.bleTypeId,
  }) : super(key: key);
  final ScanResult scanResult;
  final int bleTypeId;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to pair this device?',
                  style: TextStyles.normalTextStyle(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.showOverlay(asyncFunction: () async {
                          await scanResult.device.connect();
                          final currentState =
                              await scanResult.device.state.first;
                          if (currentState == BluetoothDeviceState.connected) {
                            // final bool? res =
                            //     await Get.find<UserDevicesController>()
                            //         .postNewUserDevice(
                            //   deviceName: scanResult.device.name,
                            //   uuid: scanResult.device.id.toString(),
                            //   bleTypeId: bleTypeId,
                            // );
                            // if ((res ?? false) && context.mounted) {
                            //   showToast(
                            //     'Device Connected!',
                            //     context,
                            //   );
                            // } else {
                            //   showToast(
                            //     'Connection failed! Try again.',
                            //     context,
                            //   );
                            // }
                          }
                        });
                      },
                      child: const Text('Pair'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeightScaleWidget extends StatefulWidget {
  const WeightScaleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<WeightScaleWidget> createState() => _WeightScaleWidgetState();
}

class _WeightScaleWidgetState extends State<WeightScaleWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 5));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
        initialData: const [],
        stream: FlutterBluePlus.instance.scanResults,
        builder: (context, snapshot) {
          final dataList = snapshot.data!
              .where((element) => element.device.name == 'Health Scale')
              .toList();
          return dataList.isEmpty
              ? const Text("Please step on weighing scale")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dataList
                      .map(
                        (result) => ScanResultTile(
                          result: result,
                          onTap: () {
                            Get.dialog(
                              PairDialogue(
                                scanResult: result,
                                bleTypeId: 18,
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                );
        });
  }
}

DateFormat stringDateWithTZ = DateFormat("yyyy-MM-ddTHH:mm:ss.S");