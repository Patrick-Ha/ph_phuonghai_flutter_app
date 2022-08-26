import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

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
  String key;
  String type;
  String model;
  String friendlyName;
  String description;

  DateTime dateSync;

  bool isActived;
  bool enable;
  bool isBusy;

  String get getSyncDate =>
      "${dateSync.hour.toString().padLeft(2, '0')}:${dateSync.minute.toString().padLeft(2, '0')}, ${dateSync.day.toString().padLeft(2, '0')}/${dateSync.month.toString().padLeft(2, '0')}";

  Device({
    required this.key, // so S/N
    required this.type,
    required this.model,
    required this.friendlyName,
    required this.description,
    required this.dateSync,
    this.isActived = true,
    this.enable = true,
    this.isBusy = false,
  });
}

class DeviceModel extends Device {
  List<SensorModel> sensors = [];

  DeviceModel({
    required String key,
    required String type,
    required String model,
    required String friendlyName,
    required String description,
    required DateTime dateSync,
  }) : super(
          key: key,
          type: type,
          model: model,
          friendlyName: friendlyName,
          description: description,
          dateSync: dateSync,
        );

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      key: json['SerialNumber'],
      type: json['Type'],
      model: json['Model'],
      description: json["Description"],
      friendlyName: json["FriendlyName"],
      dateSync: DateTime.parse(json["DateSync"]),
    );
  }
}

class SensorModel {
  String key;
  String name;
  String status;
  String unit;

  num value;
  num minAlarm;
  num maxAlarm;

  Color color;

  bool activeAlarm;

  IconData icon;

  SensorModel({
    required this.key,
    required this.name,
    required this.status,
    required this.unit,
    required this.value,
    this.activeAlarm = false,
    this.minAlarm = 0,
    this.maxAlarm = 1000,
    this.icon = EvaIcons.checkmarkCircle2Outline,
    this.color = Colors.blueGrey,
  });

  factory SensorModel.fromJson(String sn, Map<String, dynamic> json) {
    return SensorModel(
      key: sn,
      name: json["SensorType"],
      status: json["Status"],
      unit: iaqUnit[json["Unit"]] ?? json["Unit"],
      value: json["Value"],
    );
  }
}
