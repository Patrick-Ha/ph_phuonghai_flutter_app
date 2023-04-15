import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/device.dart';

class Refrigerator extends Device {
  RefriItem sensor = RefriItem(key: '');
  final markers = <Marker>[].obs;
  int updateCamera = 1; // 0: not update, 1: update first, 2: update last

  Refrigerator({
    required int id,
    required String key,
    required String type,
    required String model,
    required String friendlyName,
    required String description,
  }) : super(
          id: id,
          key: key,
          type: type,
          model: model,
          friendlyName: friendlyName,
          description: description,
        );

  factory Refrigerator.fromJson(Map<String, dynamic> json) {
    return Refrigerator(
      id: json['Id'],
      key: json['SerialNumber'],
      type: json['Type'],
      model: json['Model'],
      description: json["Description"],
      friendlyName: json["FriendlyName"],
    );
  }
}

class RefriItem {
  String key;

  String timeUpdated;
  double lat;
  double long;
  final gpsState = 'Good'.obs;

  final isSelected = false.obs;

  SensorModel pin = SensorModel(
    key: '',
    name: 'Pin',
    unit: '%',
    icon: Icons.battery_5_bar,
  );
  SensorModel lock = SensorModel(
    key: '',
    name: 'Lock',
    unit: '-',
    icon: Icons.lock_open,
  );
  SensorModel temp = SensorModel(key: '', name: 'Temp', unit: 'oC');

  RefriItem({
    required this.key,
    this.timeUpdated = '',
    this.lat = 0,
    this.long = 0,
  });

  processPinLock() {
    if (lock.val.value == 0) {
      lock.icon = Icons.lock_open;
      lock.color.value = Colors.green;
    } else {
      lock.icon = Icons.lock;
      lock.color.value = Colors.red;
    }
  }
}
