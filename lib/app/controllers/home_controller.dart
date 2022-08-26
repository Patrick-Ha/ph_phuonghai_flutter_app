import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/data/provider/api.dart';
import 'package:phuonghai/app/helper/helper.dart';

class HomeController extends GetxController {
  Timer? timer;
  final apiClient = ApiClient();
  final isLoading = false.obs;
  final Rx<List<GroupModel>> listGroup =
      Rx<List<GroupModel>>([GroupModel(name: "allDevices")]);

  final groupIndex = 0.obs;
  GroupModel get selectedGroup => listGroup.value[groupIndex.value];

  final detailDevice = [].obs;
  final email = ''.obs;
  final version = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    Helper.showLoading("loading".tr);
    final boxAuth = await Hive.openBox("authentication");
    final packageInfo = await PackageInfo.fromPlatform();
    email.value = boxAuth.get("email");
    version.value = packageInfo.version;

    listGroup.value[0].devices.assignAll(await apiClient.fetchUserDevices());
    await updateSensorData();
    getDevicesOfGroup();

    EasyLoading.dismiss();

    timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => updateSensorData(),
    );
  }

  @override
  void onClose() {
    timer?.cancel();
    listGroup.value.clear();
    super.onClose();
  }

  addDetailDevice(dynamic model) {
    detailDevice.clear();
    detailDevice.add(model);
  }

  updateSensorData() async {
    isLoading.value = true;
    for (var element in listGroup.value[0].devices) {
      await apiClient.getSensorOfDevice(element);
    }
    detailDevice.refresh();
    listGroup.refresh();
    isLoading.value = false;
  }

  getDevicesOfGroup() {
    apiClient.userConfig['groups'].forEach(
      (key, value) {
        final group = GroupModel(name: key);
        // Kiem tra thiet bi
        if (value != null) {
          for (final element in value) {
            final index =
                listGroup.value[0].devices.indexWhere((e) => e.key == element);
            if (index != -1) {
              group.devices.add(listGroup.value[0].devices[index]);
            }
          }
        }
        listGroup.value.add(group);
      },
    );
  }

  deleteGroup(String name) {
    apiClient.userConfig['groups'].remove(name);
    listGroup.value.removeWhere((element) => element.name == name);
    groupIndex.value = 0;
    listGroup.refresh();
    apiClient.updateConfigToFirestore();
  }

  createNewGroup(String name) {
    final newGroup = GroupModel(name: name);
    listGroup.value.add(newGroup);
    apiClient.userConfig['groups'][name] = [];
    listGroup.refresh();
    apiClient.updateConfigToFirestore();
  }

  renameGroup(String oldName, String newName) {
    final listDevice = apiClient.userConfig['groups'].remove(oldName);
    apiClient.userConfig['groups'][newName] = listDevice;
    listGroup.refresh();
    apiClient.updateConfigToFirestore();
  }

  addDeviceToGroup(String groupName, String sn) {
    apiClient.userConfig['groups'][groupName].add(sn);
    listGroup.refresh();
    apiClient.updateConfigToFirestore();
  }

  removeDeviceFromGroup(String groupName, String sn) {
    apiClient.userConfig['groups'][groupName].remove(sn);
    listGroup.refresh();
    apiClient.updateConfigToFirestore();
  }

  updateAlarmSensor(SensorModel sensor) {
    apiClient.userConfig[sensor.key][sensor.name] = {
      'active': sensor.activeAlarm,
      'lower': sensor.minAlarm,
      'upper': sensor.maxAlarm,
    };
    apiClient.checkAlarm(sensor);
    detailDevice.refresh();
    listGroup.refresh();
    apiClient.updateConfigToFirestore();
  }

// End
}
