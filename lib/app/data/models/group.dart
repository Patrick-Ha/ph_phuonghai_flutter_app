import 'package:get/get.dart';

class GroupModel {
  final name = ''.obs;
  final visible = true.obs;
  final int id;
  final int oder;

  final devices = [].obs;

  GroupModel({
    required this.id,
    required this.oder,
    // required this.name,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['Id'],
      oder: json['Orderno'],
    );
  }
}
