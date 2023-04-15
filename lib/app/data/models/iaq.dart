import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final iaqIndex = 0.obs;
  String iaqStatus;
  List<IaqSensor> sensors = [];

  IaqModel({
    required int id,
    required String key,
    required String type,
    required String model,
    required String friendlyName,
    required String description,
    this.iaqStatus = "Good",
  }) : super(
          id: id,
          key: key,
          type: type,
          model: model,
          friendlyName: friendlyName,
          description: description,
        );

  factory IaqModel.fromJson(Map<String, dynamic> json) {
    return IaqModel(
      id: json['Id'],
      key: json['SerialNumber'],
      type: json['Type'],
      model: json['Model'],
      description: json["Description"],
      friendlyName: json["FriendlyName"],
    );
  }
}

class IaqSensor {
  String key;
  String name;
  String unit;

  final status = ''.obs;
  final Rx<double> val = 0.0.obs;

  final color = Colors.grey.obs;
  set setColor(String status) {
    color.value = iaqColorMap[status] ?? Colors.blueGrey;
  }

  IaqSensor({
    required this.key,
    required this.name,
    required this.unit,
  });

  factory IaqSensor.fromJson(String sn, Map<String, dynamic> json) {
    return IaqSensor(
      key: sn,
      name: json["SensorType"],
      // status: json["Status"],
      unit: iaqUnit[json["Unit"]] ?? json["Unit"],
      // value: json["Value"],
      // color: iaqColorMap[json["Status"]] ?? Colors.blueGrey,
    );
  }
}
