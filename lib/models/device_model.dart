import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/meteocons_icons.dart';
import 'package:fluttericon/typicons_icons.dart';

// Sensor for Bestlab devices reference
const Map<String, dynamic> sensorBestlabRef = {
  "Temperature": {
    "icon": Typicons.temperatire,
    "unit": "°C",
    "vi": "Nhiệt độ",
    "min": 0,
    "max": 60
  },
  "Humidity": {
    "icon": LineariconsFree.drop,
    "unit": "%",
    "vi": "Độ ẩm",
    "min": 0,
    "max": 100
  },
  "Light": {
    "icon": LineariconsFree.sun,
    "unit": "Lux",
    "vi": "Độ sáng",
    "min": 0,
    "max": 1000
  },
  "Velocity": {
    "icon": Meteocons.wind,
    "unit": "m/s",
    "vi": "Tốc độ gió",
    "min": 0,
    "max": 2
  },
  "pH": {
    "icon": LineariconsFree.funnel,
    "unit": "pH",
    "vi": "pH",
    "min": 0,
    "max": 14
  },
  "TVOC": {
    "icon": LineariconsFree.layers,
    "unit": "ppm",
    "vi": "TVOC",
    "min": 0,
    "max": 1000
  },
  "PM25": {
    "icon": LineariconsFree.layers,
    "unit": "µg/m³",
    "vi": "PM2.5",
    "min": 0,
    "max": 100
  },
  "CO2": {
    "icon": LineariconsFree.layers,
    "unit": "ppm",
    "vi": "CO2",
    "min": 0,
    "max": 5000
  },
  "IAQ": {
    "icon": LineariconsFree.layers,
    "unit": "IAQ",
    "vi": "IAQ",
    "min": 0,
    "max": 65
  },
  "default": {"icon": LineariconsFree.layers},
};

// Control button bestlab reference
const Map<String, dynamic> buttonBestlabRef = {
  "lamp": {
    "scr": "assets/icons/lamp.svg",
    "vi": "Đèn Tủ",
  },
  "fan": {
    "scr": "assets/icons/turbine.svg",
    "vi": "Quạt Hút",
  },
};

// IAQ color code
const Map<String, dynamic> iaqColor = {
  "Error": Colors.grey,
  "Excellent": Colors.green,
  "Good": Colors.lightGreen,
  "Moderate": Colors.yellow,
  "Poor": Colors.orange,
  "Unhealthy": Colors.red,
};

const Map<String, String> iaqUnit = {
  "oC": "°C",
  "ug/m3": "µg/m³",
};

class DeviceModel {
  String key; // Day la so SN cua thiet bi
  DateTime dateSync;
  DateTime createAt = DateTime.now();
  String description;
  String friendlyName;
  bool isActived;
  bool enable;
  String model;
  String type;
  bool isLockControl;
  List<dynamic> sensors = [];
  List<ButtonModel> buttons = [];

  String get getSyncDate =>
      "${dateSync.hour.toString().padLeft(2, '0')}:${dateSync.minute.toString().padLeft(2, '0')}, ${dateSync.day.toString().padLeft(2, '0')}/${dateSync.month.toString().padLeft(2, '0')}";

  DeviceModel({
    required this.key, // Day la Key cua Map, so S/N
    required this.dateSync,
    // required this.createAt,
    required this.description,
    required this.friendlyName,
    this.isActived = true,
    required this.model,
    required this.type,
    this.enable = true,
    this.isLockControl = false,
  });

  factory DeviceModel.fromJson(Map<dynamic, dynamic> json) {
    return DeviceModel(
      dateSync: DateTime.parse(json["DateSync"]),
      // createAt: DateTime.parse(json["createAt"]),
      description: json["Description"],
      friendlyName: json["FriendlyName"],
      // isActived: json["IsActive"],
      // isLockControl: json["lockControl"],
      model: json["Model"],
      type: json["Type"],
      key: json["SerialNumber"],
      // enable: json["enable"],
    );
  }

  void updateFromJson(Map<dynamic, dynamic> json) {
    dateSync = DateTime.tryParse(json["syncAt"]) ?? DateTime.now();
    description = json["description"] ?? description;
    friendlyName = json["friendlyName"] ?? friendlyName;
    isActived = json["isActived"] ?? isActived;
    isLockControl = json["lockControl"] ?? isLockControl;
    model = json["model"] ?? model;
    type = json["type"] ?? type;
    enable = json["enable"] ?? enable;
  }
}

class SensorIaq {
  String key; // Day la so S/N cua thiet bi
  String name;
  num value;
  String status;
  String unit;
  Color color;

  SensorIaq({
    required this.key,
    required this.name,
    required this.value,
    required this.status,
    required this.unit,
    required this.color,
  });

  factory SensorIaq.fromJson(String sn, Map<dynamic, dynamic> json) {
    return SensorIaq(
      key: sn,
      name: json["SensorType"],
      status: json["Status"],
      color: iaqColor[json["Status"]] ?? Colors.blueGrey,
      value: json["Value"],
      unit: iaqUnit[json["Unit"]] ?? json["Unit"],
    );
  }
}

class SensorSmartpH {
  String key; // Day la so S/N cua thiet bi
  String name;
  num value;
  String status;
  String unit;
  Color color;
  bool activeAlarm; // false: ko cho phep
  num minAlarm;
  num maxAlarm;

  SensorSmartpH({
    required this.key,
    required this.name,
    required this.value,
    required this.status,
    required this.unit,
    this.color = Colors.blueGrey,
    this.activeAlarm = false,
    this.minAlarm = 0,
    this.maxAlarm = 1000,
  });

  factory SensorSmartpH.fromJson(String sn, Map<dynamic, dynamic> json) {
    return SensorSmartpH(
      key: sn,
      name: json["SensorType"],
      status: json["Status"],
      value: json["Value"],
      unit: json["Unit"],
    );
  }
}

// class SensorModel {
//   String key;
//   String unit;
//   String status;
//   String vi;
//   num value;
//   double minR, maxR, percent;
//   bool isSelect = false;
//   IconData icon;
//   Color color;

//   // For chart
//   num? averageOfDay;
//   num? lowestOfDay;
//   num? highestOfDay;
//   List<Map<String, dynamic>> dataChart = [];

//   SensorModel({
//     required this.key,
//     required this.unit,
//     required this.status,
//     required this.value,
//     required this.icon,
//     required this.vi,
//     required this.color,
//     this.minR = 0,
//     this.percent = 0,
//     this.maxR = 100,
//   });
//   toJson() {
//     return {
//       "Key": key,
//       "Measure": unit,
//       "Status": status,
//       "Value": value,
//     };
//   }

//   factory SensorModel.fromJson(String key, Map<dynamic, dynamic> json) {
//     return SensorModel(
//       key: key,
//       status: json["status"],
//       value: json["value"],
//       unit: json["unit"] == 'ppb' ? 'ppb' : sensorBestlabRef[key]["unit"],
//       icon: sensorBestlabRef[key]["icon"],
//       vi: sensorBestlabRef[key]["vi"],
//       color: iaqColor[json["status"]]["color"],
//       percent: iaqColor[json["status"]]["percent"],
//       minR: sensorBestlabRef[key]["min"].toDouble(),
//       maxR: sensorBestlabRef[key]["max"].toDouble(),
//     );
//   }
// }

class ButtonModel {
  String key;
  String svgScr;
  bool isActived;

  ButtonModel(
      {required this.key, required this.isActived, required this.svgScr});
}
