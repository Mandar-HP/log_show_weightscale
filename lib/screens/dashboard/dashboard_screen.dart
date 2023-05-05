import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../global/methods/methods.dart';
import 'drawer/drawer_items.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = "/dashboardScreen";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  DateTime? currentBackPressTime;
  bool accpectPermission = false;
  bool _exitInitialized = false;
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onAttemptToExit(BuildContext context) async {
    if (_exitInitialized) {
      exit(0);
    } else {
      _exitInitialized = true;
    }
    showToast("Press again to exit!", context);
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        _exitInitialized = false;
        timer.cancel();
      },
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onAttemptToExit(context),
      child: Scaffold(
          drawer: const DrawerSide(),
          key: _key,
          appBar: AppBar(
            title: const Text("Dashboard"),         
          ),
          body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
             Text("Dashboard"),
            ],
          ),
        )
      
    );
  }

  showPermissionDialog(BuildContext context,
      {required String description,
      required VoidCallback onOk,
      required VoidCallback onCancel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text("Request Permissions!!"),
          content: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  description,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: onCancel,
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: onOk,
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
