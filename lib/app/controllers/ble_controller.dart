import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phuonghai/app/data/models/ble.dart';
import 'package:phuonghai/app/helper/helper.dart';

class BleController extends GetxController {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  final isBleOn = false.obs;
  final bleDevices = [].obs;

  @override
  void onInit() async {
    super.onInit();
    scanBle();
  }

  Future<bool> checkBleState() async {
    if (await Permission.bluetooth.request().isGranted) {
      // Check bluetooth on
      if (await flutterBlue.isOn) {
        return true;
      } else {
        return await flutterBlue.turnOn();
      }
    } else {
      return false;
    }
  }

  scanBle() async {
    Helper.showLoading("loading".tr);
    bleDevices.clear();
    isBleOn.value = await checkBleState();
    if (isBleOn.value) {
      final results = await flutterBlue.startScan(
        timeout: const Duration(seconds: 5),
      );
      for (ScanResult r in results) {
        if (r.device.name != "") {
          final bleDevice = BleDevice(
            device: r.device,
            rssi: r.rssi,
          );
          bleDevices.add(bleDevice);
        }
      }

      bleDevices.sort((a, b) => b.rssi.compareTo(a.rssi));
    }

    Helper.dismissLoad();
  }

  Future<bool> connect(BleDevice d) async {
    Helper.showLoading("connecting".tr);
    await d.device.disconnect();
    try {
      print("connecting...");
      await d.device.connect(
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );
      print("connected------------->");
      d.services = await d.device.discoverServices();
      Helper.dismissLoad();
      return true;
    } catch (e) {
      print("Connect BLE error: " + e.toString());
      return false;
    }
  }

  // End
}
