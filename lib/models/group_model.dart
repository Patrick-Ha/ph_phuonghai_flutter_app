import 'package:phuonghai/models/device_model.dart';

class GroupModel {
  String name;
  String dl = "";
  bool isSelect = false;
  List<DeviceModel> devices = [];

  GroupModel({required this.name});
  toJson() {
    return {
      "name": name,
      "devices": dl,
    };
  }
}
