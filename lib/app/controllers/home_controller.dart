import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/data/models/user.dart';
import 'package:phuonghai/app/data/provider/api.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/routes/app_pages.dart';

class HomeController extends GetxController {
  Timer? timer;
  late final ApiClient apiClient;

  final detailDevice = [];
  final version = ''.obs;
  final user = UserModel(id: 0, email: "", token: "").obs;
  final visible = false.obs;
  final admin = false.obs;

  final allDevicesOfUser = [];

  // Group
  final selectedGroup = 0.obs;
  final allGroups = <GroupModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    Helper.showLoading("loading".tr);

    final packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    final boxAuth = await Hive.openBox("authentication");
    final log = boxAuth.get("isLogged", defaultValue: null);
    if (log == null) {
      EasyLoading.dismiss();
      Get.offAndToNamed(Routes.LOGIN);
    } else {
      user.value = UserModel.fromJson(Map<String, dynamic>.from(log));
      user.refresh();

      apiClient = ApiClient(
          user: user.value,
          dio: Dio(
            BaseOptions(
              baseUrl: baseUrl,
              headers: {
                "Content-Type": "application/json",
                "Authorization": user.value.token,
              },
            ),
          ));

      if (user.value.email == 'admin' ||
          user.value.email == 'diepha@gmail.com') {
        admin.value = true;
        await apiClient.getAllDevices();
        await apiClient.getAllUsers();
      } else {
        admin.value = false;
      }

      // Lấy tất cả thiết bị người dùng Sở hữu
      allDevicesOfUser.addAll(await apiClient.fetchUserDevices());
      updateSensorData(true);

      // Fetch all group
      do {
        allGroups.assignAll(
          await apiClient.getAllGroupOfUser(allDevicesOfUser),
        );
      } while (allGroups.isEmpty);

      allGroups.sort((a, b) => a.oder.compareTo(b.oder));
      // Add device to Group
      for (var group in allGroups) {
        final listDevices = await apiClient.getDeviceOfGroup(group.id);

        for (var d in listDevices) {
          final device = allDevicesOfUser.firstWhere(
            (element) => element.key == d['Device']['SerialNumber'],
            orElse: () => null,
          );
          if (device == null) {
            // Xoa thiet bi nay ra khoi nhom
            await apiClient.removeDeviceToGroup(d["Id"]);
          } else {
            device.idInGroup = d["Id"];
            group.devices.add(device);
          }
        }
      }
      EasyLoading.dismiss();

      timer = Timer.periodic(
        const Duration(seconds: 60),
        (_) => updateSensorData(false),
      );
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  addDetailDevice(dynamic model) {
    if (visible.isTrue) {
      if (model.key == detailDevice[0].key) {
        visible.value = false;
        model.isSelected.value = false;
      } else {
        detailDevice[0].isSelected.value = false;
        detailDevice[0] = model;
        visible.value = false;
        detailDevice[0].isSelected.value = true;
        Future.delayed(const Duration(milliseconds: 20), () {
          visible.value = true;
        });
      }
    } else {
      detailDevice.clear();
      detailDevice.add(model);
      visible.value = true;
      model.isSelected.value = true;
    }
  }

  updateSensorData(bool isFirst) async {
    for (var element in allDevicesOfUser) {
      await apiClient.getSensorOfDevice(element, isFirst);
    }
  }

  Future<void> deleteGroup(int id) async {
    allGroups.removeWhere((element) => element.id == id);
    await apiClient.deleteGroup(id);
  }

  Future<void> createNewGroup(String name, int order, String des) async {
    final id = await apiClient.createGroup(
      name,
      order,
      des,
    );

    if (id != 0) {
      final g = GroupModel(id: id, oder: order);
      g.name.value = name;
      allGroups.add(g);
    }
  }

  Future<void> renameGroup(int id, String newName) async {
    await apiClient.renameGroup(id, newName);
  }

  Future<void> addDeviceToGroup(int idGroup, int idDevice) async {
    await apiClient.addDeviceToGroup(idGroup, idDevice);
  }

  Future<void> removeDeviceFromGroup(int idInGroup) async {
    await apiClient.removeDeviceToGroup(idInGroup);
  }

  updateAlarmSensor(SensorModel sensor) {
    if (sensor.activeAlarm == 0) {
      apiClient.editAlarmSensor(sensor.id, null, null);
    } else if (sensor.activeAlarm == 1) {
      apiClient.editAlarmSensor(sensor.id, sensor.minAlarm, sensor.maxAlarm);
    } else {
      apiClient.editAlarmSensor(sensor.id, sensor.maxAlarm, sensor.minAlarm);
    }
    apiClient.checkAlarm(sensor);
  }

// End
}
