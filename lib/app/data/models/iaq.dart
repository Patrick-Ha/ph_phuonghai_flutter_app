import 'package:flutter/material.dart';

import 'device.dart';

const Map<String, String> iaqUnit = {
  "oC": "°C",
  "ug/m3": "µg/m³",
};

const Map<String, dynamic> iaqColorMap = {
  "Error": Colors.grey,
  "Excellent": Colors.green,
  "Good": Colors.lightGreen,
  "Moderate": Colors.yellow,
  "Poor": Colors.orange,
  "Unhealthy": Colors.red,
};

class IaqModel extends Device {
  Color _iaqColor = Colors.white;
  int iaqIndex;
  String iaqStatus;
  List<IaqSensor> sensors = [];

  set setColor(String stat) => _iaqColor = iaqColorMap[stat] ?? Colors.blueGrey;
  Color get getColor => _iaqColor;

  IaqModel({
    required String key,
    required String type,
    required String model,
    required String friendlyName,
    required String description,
    required DateTime dateSync,
    this.iaqIndex = 0,
    this.iaqStatus = "Good",
  }) : super(
          key: key,
          type: type,
          model: model,
          friendlyName: friendlyName,
          description: description,
          dateSync: dateSync,
        );

  factory IaqModel.fromJson(Map<String, dynamic> json) {
    return IaqModel(
      key: json['SerialNumber'],
      type: json['Type'],
      model: json['Model'],
      description: json["Description"],
      friendlyName: json["FriendlyName"],
      dateSync: DateTime.parse(json["DateSync"]),
    );
  }
}

class IaqSensor {
  String key;
  String name;
  String status;
  String unit;

  num value;
  Color color;

  IaqSensor({
    required this.key,
    required this.name,
    required this.status,
    required this.unit,
    required this.value,
    required this.color,
  });

  factory IaqSensor.fromJson(String sn, Map<String, dynamic> json) {
    return IaqSensor(
      key: sn,
      name: json["SensorType"],
      status: json["Status"],
      unit: iaqUnit[json["Unit"]] ?? json["Unit"],
      value: json["Value"],
      color: iaqColorMap[json["Status"]] ?? Colors.blueGrey,
    );
  }
}
