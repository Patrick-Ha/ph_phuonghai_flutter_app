import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phuonghai/models/device_model.dart';
import 'package:phuonghai/models/group_model.dart';

class DeviceHttp extends ChangeNotifier {
  // 0: binh thuong;
  // 1: lan dau khoi tao, dang ban;
  // 2: dang ban, khong phai lan dau
  int isBusy = 1;

  String _token = "";

  Timer? timer;

  final Dio dioDevice = Dio();

  // Firebase firestore
  final CollectionReference collectionUsersRef =
      FirebaseFirestore.instance.collection('users');
  Map<String, dynamic> userConfig = {};

  String? email, version;

  final List<GroupModel> _groups = [];
  List<GroupModel> get groups => _groups;
  int groupSelected = 0;

  void initDeviceHttp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;

    final boxAuth = await Hive.openBox("authentication");
    final pwd = boxAuth.get("pwd");

    email = boxAuth.get("email");
    _token = "Basic ${base64.encode(utf8.encode("$email:$pwd"))}";

    try {
      final response = await dioDevice.post(
        'https://thegreenlab.xyz/Users/Auth/Login',
        data: {'Email': email, 'Password': pwd},
      );

      if (response.statusCode == 201) {
        _groups.clear();
        _groups.add(GroupModel(name: 'txtAllDevices'));

        for (var item in response.data["userDevices"]) {
          final resp = await dioDevice.get(
            'https://thegreenlab.xyz/Devices/Search?SerialNumber=${item['DeviceSerialNumber']}',
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": _token, // set content-length
              },
            ),
          );
          if (resp.statusCode == 200) {
            var model = DeviceModel.fromJson(resp.data);
            _groups[0].devices.add(model);
          }
        }
      }
      // ignore: empty_catches
    } on DioError catch (e) {
      debugPrint(e.toString());
    }
    await fetchAllData();

    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchAllData();
    });
  }

  void disposeTimer() {
    isBusy = 1;
    timer?.cancel();
  }

  fetchAllData() async {
    if (isBusy != 1) {
      isBusy = 2;
      notifyListeners();
    } else {
      // Lan dau tien dang nhap
      // print(email);
      // await collectionUsersRef.doc('hello@phuonghai.com').set({"123": "Asds"});
      final doc = await collectionUsersRef.doc(email).get();
      if (doc.exists) {
        userConfig = doc.data() as Map<String, dynamic>;
      } else {
        // Chua co
        userConfig = {"groups": {}};
        await collectionUsersRef.doc(email).set(userConfig);
      }
    }

    for (var item in _groups[0].devices) {
      try {
        final response = await dioDevice.get(
          "https://thegreenlab.xyz/Datums/LastestDataByDevice?DeviceSerialNumber=${item.key}",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": _token, // set content-length
            },
          ),
        );

        // Kiem tra device nay co tren fireStore chua
        if (!userConfig.containsKey(item.key) && item.type != "Air Node") {
          userConfig[item.key] = {};
        }

        if (response.statusCode == 200) {
          for (var i in response.data) {
            final index = item.sensors
                .indexWhere((element) => element.name == i['SensorType']);
            if (index == -1) {
              // Chua ton tai
              if (item.type == "Air Node") {
                final sensor = SensorIaq.fromJson(item.key, i);
                item.sensors.add(sensor);
              } else {
                final sensor = SensorSmartpH.fromJson(item.key, i);

                // Lan dau khoi tao
                if (userConfig[item.key].containsKey(sensor.name)) {
                  // Da co tren FireStore => dong bo
                  sensor.activeAlarm =
                      userConfig[item.key][sensor.name]['active'];
                  sensor.minAlarm = userConfig[item.key][sensor.name]['lower'];
                  sensor.maxAlarm = userConfig[item.key][sensor.name]['upper'];
                } else {
                  // Chua co, tu khoi tao
                  userConfig[item.key][sensor.name] = {};
                  userConfig[item.key][sensor.name]['active'] = false;
                  userConfig[item.key][sensor.name]['lower'] = 0;
                  userConfig[item.key][sensor.name]['upper'] = 1000;
                }

                // Kiem tra Alarm
                if (sensor.status == "Error") {
                  sensor.color = Colors.grey;
                } else if (sensor.status == "Calibrating") {
                  sensor.color = Colors.blueGrey;
                } else {
                  // Good
                  if (sensor.activeAlarm == false) {
                    sensor.color = Colors.blueGrey;
                  } else {
                    if (sensor.minAlarm <= sensor.value &&
                        sensor.value <= sensor.maxAlarm) {
                      sensor.color = Colors.green;
                    } else {
                      sensor.color = Colors.red;
                    }
                  }
                }
                item.sensors.add(sensor);
              }
            } else {
              // Da co
              item.sensors[index].status = i["Status"];
              item.sensors[index].value = i["Value"];

              if (item.type == "Air Node") {
                // Cap nhap lai mau sac
                item.sensors[index].color =
                    iaqColor[i["Status"]] ?? Colors.blueGrey;
              } else {
                // Kiem tra Alarm
                if (item.sensors[index].status == "Error") {
                  item.sensors[index].color = Colors.grey;
                } else if (item.sensors[index].status == "Calibrating") {
                  item.sensors[index].color = Colors.blueGrey;
                } else {
                  // Good
                  if (item.sensors[index].activeAlarm == false) {
                    item.sensors[index].color = Colors.blueGrey;
                  } else {
                    if (item.sensors[index].minAlarm <=
                            item.sensors[index].value &&
                        item.sensors[index].value <=
                            item.sensors[index].maxAlarm) {
                      item.sensors[index].color = Colors.green;
                    } else {
                      item.sensors[index].color = Colors.red;
                    }
                  }
                }
              }
            }
            item.dateSync =
                DateTime.parse(i["ReceivedDate"]).add(const Duration(hours: 7));
          }

          if (isBusy == 1) {
            // Dong bo Alarm
            if (item.type == "Air Node") {
              item.sensors.sort((a, b) => a.name.compareTo(b.name));
            }
          }
        }
        // ignore: empty_catches
      } catch (e) {
        debugPrint("Error [fetchAllData]: " + e.toString());
      }
    }
    // Fetch group
    if (isBusy == 1) {
      await collectionUsersRef.doc(email).update(userConfig);
      // Lan dau tien
      if (userConfig.containsKey('groups')) {
        userConfig['groups'].forEach((key, value) {
          final group = GroupModel(name: key);
          // Kiem tra cac thi bi san co
          if (value != null) {
            for (var element in value) {
              final index =
                  _groups[0].devices.indexWhere((e) => e.key == element);
              if (index != -1) {
                // Co thiet bi trong _deviceList
                group.devices.add(_groups[0].devices[index]);
              }
            }
          }
          _groups.add(group);
        });
      }
    }

    isBusy = 0;
    notifyListeners();
  }

  syncAlarmConfig(SensorSmartpH sensor) async {
    userConfig[sensor.key][sensor.name] = {
      'active': sensor.activeAlarm,
      'lower': sensor.minAlarm,
      'upper': sensor.maxAlarm,
    };
    if (sensor.status == "Error") {
      sensor.color = Colors.grey;
    } else if (sensor.status == "Calibrating") {
      sensor.color = Colors.blueGrey;
    } else {
      // Good
      if (sensor.activeAlarm == false) {
        sensor.color = Colors.blueGrey;
      } else {
        if (sensor.minAlarm <= sensor.value &&
            sensor.value <= sensor.maxAlarm) {
          sensor.color = Colors.green;
        } else {
          sensor.color = Colors.red;
        }
      }
    }
    await collectionUsersRef.doc(email).update(userConfig);
  }

  updateGroupsToFirebase() async {
    await collectionUsersRef.doc(email).update(userConfig);
    notifyListeners();
  }

  Future<bool> addDevice(
      {String? model, String? seri, String? name, String? des}) async {
    try {
      // final response = await http.post(
      //   url,
      //   headers: {
      //     "Content-Type": "application/json",
      //     'Accept': 'application/json',
      //     "Authorization":
      //         "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
      //   },
      //   body: jsonEncode({
      //     'DateSync': DateTime.now()
      //         .subtract(const Duration(hours: 7))
      //         .toIso8601String(),
      //     'Description': des,
      //     'FriendlyName': name,
      //     'Model': model,
      //     'SerialNumber': seri,
      //     'IsActive': true,
      //     'Devicegroup': {},
      //     'Type': model,
      //     'LabSerialNumber': '',
      //   }),
      // );

      // print(response.statusCode);
      // print(response.body);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
