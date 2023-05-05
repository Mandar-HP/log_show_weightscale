import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wehealth/controller/storage_controller.dart';
import 'package:wehealth/screens/dashboard/drawer/link_device/link_device_screen.dart';
import '../../../global/constants/images.dart';
import '../../../global/methods/methods.dart';

class DrawerSide extends StatelessWidget {
  const DrawerSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 140,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.drawerHeader),
                        fit: BoxFit.cover)),
              ),
            ),


            //
            ListTile(
              onTap: (() {
                Get.back();

                Get.to(() => const LinkDeviceScreen());
              }),
              leading: Icon(Icons.device_hub),
                                 
              title: const Text("Link Device"),
            ),

            //
            ListTile(
              onTap: () async {
              
                await onWillPopLogout(context);
                Get.find<StorageController>().prefs.clear();

              },
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
            ),
          ],
        ),
      ),
    ));
  }
}
