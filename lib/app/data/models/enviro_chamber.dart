import 'package:phuonghai/app/data/models/device.dart';
import 'package:get/get.dart';

class EnviroChamberModel extends Device {
  List<SensorModel> sensors = [];
  final operation = "N/A".obs;
  final mode = "N/A".obs;

  final heater = 0.obs;
  final cooler = 0.obs;
  final humidity = 0.obs;
  final moise = 0.obs;

  final tempSet = 0.0.obs;
  final tempNow = 0.0.obs;
  final humSet = 0.0.obs;
  final humNow = 0.0.obs;

  final countTimer = 0.obs;

  EnviroChamberModel({
    required int id,
    required String key,
    required String type,
    required String model,
    required String friendlyName,
    required String description,
    required String camUrl1,
    required String camUrl2,
    required String camUrl3,
  }) : super(
          id: id,
          key: key,
          type: type,
          model: model,
          friendlyName: friendlyName,
          description: description,
          camUrl1: camUrl1,
          camUrl2: camUrl2,
          camUrl3: camUrl3,
        );

  factory EnviroChamberModel.fromJson(Map<String, dynamic> json) {
    return EnviroChamberModel(
      id: json['Id'],
      key: json['SerialNumber'],
      type: json['Type'],
      model: json['Model'],
      camUrl1: json["camUrl1"] ?? "",
      camUrl2: json["camUrl2"] ?? "",
      camUrl3: json["camUrl3"] ?? "",
      description: json["Description"],
      friendlyName: json["FriendlyName"],
    );
  }
}
