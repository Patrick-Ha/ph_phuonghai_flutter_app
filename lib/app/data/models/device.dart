import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Map<String, String> iaqUnit = {
  "oC": "°C",
  "ug/m3": "µg/m³",
  "m3": "m³",
  "m3/h": "m³/h",
};

const Map<String, dynamic> iaqColor = {
  "Error": Colors.grey,
  "Excellent": Colors.green,
  "Good": Colors.lightGreen,
  "Moderate": Colors.yellow,
  "Poor": Colors.orange,
  "Unhealthy": Colors.red,
};

class Device {
  int id;
  int idInGroup = 0;
  String key;
  String type;
  String model;
  String friendlyName;
  String description;

  final sensorsRef = [];
  final isActived = true.obs;
  final isSelected = false.obs;

  final dateSyncObs = DateTime.utc(2020).obs;
  set dateTimeSync(String date) {
    dateSyncObs.value = DateTime.parse(date);
  }

  String get getSyncDateObs =>
      "${dateSyncObs.value.hour.toString().padLeft(2, '0')}:${dateSyncObs.value.minute.toString().padLeft(2, '0')}, ${dateSyncObs.value.day.toString().padLeft(2, '0')}/${dateSyncObs.value.month.toString().padLeft(2, '0')}";

  Device({
    required this.id,
    required this.key, // so S/N
    required this.type,
    required this.model,
    required this.friendlyName,
    required this.description,
  });
}

class DeviceModel extends Device {
  List<SensorModel> sensors = [];

  DeviceModel({
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

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['Id'],
      key: json['SerialNumber'],
      type: json['Type'],
      model: json['Model'],
      description: json["Description"],
      friendlyName: json["FriendlyName"],
    );
  }
}

class SensorModel {
  String key;
  final String name;
  final String unit;
  int id;

  final status = ''.obs;
  final Rx<double> val = 0.0.obs;
  num minAlarm = 0;
  num maxAlarm = 1000;

  // 0: not active, 1: giá trị an toàn bên trong, 2: giá trị an toàn bên ngoài
  int activeAlarm = 0;
  final color = Colors.blueGrey.obs;
  IconData icon;

  SensorModel({
    required this.key,
    required this.name,
    required this.unit,
    this.id = 0,
    this.icon = Icons.check_circle,
  });

  void setAlarm(num? min, num? max) {
    if (min == null || max == null) {
      activeAlarm = 0;
    } else {
      if (min > max) {
        minAlarm = max;
        maxAlarm = min;
        activeAlarm = 2;
      } else {
        minAlarm = min;
        maxAlarm = max;
        activeAlarm = 1;
      }
    }
  }

  factory SensorModel.fromJson(String sn, Map<String, dynamic> json) {
    return SensorModel(
      key: sn,
      name: json["SensorType"],
      unit: iaqUnit[json["Unit"]] ?? json["Unit"],
    );
  }
}
