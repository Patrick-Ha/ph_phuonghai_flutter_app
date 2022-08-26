import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDevice {
  String? name;
  String? model;
  String? serialNumber;
  String? firmware;
  String? hardware;
  String? software;
  String? manufact;

  int rssi;
  BluetoothDevice device;
  List<BluetoothService>? services;

  BleDevice({
    required this.device,
    required this.rssi,
  });
}
