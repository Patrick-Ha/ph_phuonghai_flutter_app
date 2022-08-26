import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phuonghai/app/data/models/iaq.dart';

// import 'dart:html' as html;

import '../models/device.dart';

const baseUrl = 'https://thegreenlab.xyz';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );
  String _token = '', email = 'n/a';

  final CollectionReference _collectionUsersRef =
      FirebaseFirestore.instance.collection('users');

  Map<String, dynamic> userConfig = {};

  getConfigFromFirestore() async {
    final doc = await _collectionUsersRef.doc(email).get();
    if (doc.exists) {
      userConfig = doc.data() as Map<String, dynamic>;
    } else {
      // Chua co
      userConfig = {"groups": {}};
      await _collectionUsersRef.doc(email).set(userConfig);
    }
  }

  updateConfigToFirestore() {
    _collectionUsersRef.doc(email).update(userConfig);
  }

  // Fetch all device by User
  Future<List> fetchUserDevices() async {
    // Read user and pass
    final box = await Hive.openBox("authentication");
    final pwd = box.get("pwd");
    final List devices = [];
    email = box.get("email");

    await getConfigFromFirestore();

    _token = "Basic ${base64.encode(utf8.encode("$email:$pwd"))}";
    try {
      final response = await _dio.post(
        '/Users/Auth/Login',
        data: {'Email': email, 'Password': pwd},
      );

      for (var item in response.data['userDevices']) {
        final resp = await _dio.get(
          '/Devices/Search?SerialNumber=${item['DeviceSerialNumber']}',
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": _token,
            },
          ),
        );
        if (resp.data['Type'] == 'Air Node') {
          final device = IaqModel.fromJson(resp.data);
          devices.add(device);
        } else {
          final device = DeviceModel.fromJson(resp.data);
          devices.add(device);

          if (!userConfig.containsKey(device.key)) {
            userConfig[device.key] = {};
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return devices;
  }

  getSensorOfDevice(dynamic device) async {
    try {
      final response = await _dio.get(
        "/Datums/LastestDataByDevice?DeviceSerialNumber=${device.key}",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": _token, // set content-length
          },
        ),
      );
      for (var i in response.data) {
        final index = device.sensors
            .indexWhere((element) => element.name == i['SensorType']);
        if (index == -1) {
          // Chua co

          if (device.type != 'Air Node') {
            final sensor = SensorModel.fromJson(device.key, i);
            device.sensors.add(sensor);
            // Lan dau khoi tao
            if (userConfig[device.key].containsKey(sensor.name)) {
              // Da co tren FireStore => dong bo
              sensor.activeAlarm =
                  userConfig[device.key][sensor.name]['active'];
              sensor.minAlarm = userConfig[device.key][sensor.name]['lower'];
              sensor.maxAlarm = userConfig[device.key][sensor.name]['upper'];
              await _collectionUsersRef.doc(email).update(userConfig);
            } else {
              // Chua co, tu khoi tao
              userConfig[device.key][sensor.name] = {};
              userConfig[device.key][sensor.name]['active'] = false;
              userConfig[device.key][sensor.name]['lower'] = 0;
              userConfig[device.key][sensor.name]['upper'] = 1000;
            }
            checkAlarm(sensor);
          } else {
            if (i["SensorType"] == "IAQ") {
              device.iaqIndex = i["Value"];
              device.iaqStatus = i["Status"];
              device.setColor = i["Status"];
            } else {
              final sensor = IaqSensor.fromJson(device.key, i);
              device.sensors.add(sensor);
            }
          }
        } else {
          device.sensors[index].status = i["Status"];
          device.sensors[index].value = i["Value"];
          if (device.type != "Air Node") {
            checkAlarm(device.sensors[index]);
          }
        }
        device.dateSync =
            DateTime.parse(i["ReceivedDate"]).add(const Duration(hours: 7));
      }
    } catch (e) {
      debugPrint("getSensorOfDevice: " + e.toString());
    }
  }

  checkAlarm(SensorModel sensor) {
    // Kiem tra Alarm
    if (sensor.status.toLowerCase() == "error") {
      sensor.color = Colors.amber;
      sensor.icon = EvaIcons.alertTriangleOutline;
    } else if (sensor.status.toLowerCase() == "calibrating") {
      sensor.color = Colors.blueGrey;
      sensor.icon = Icons.pending_outlined;
    } else {
      if (sensor.activeAlarm == false) {
        sensor.color = Colors.blueGrey;
        sensor.icon = EvaIcons.checkmarkCircle2Outline;
      } else {
        if (sensor.minAlarm <= sensor.value &&
            sensor.value <= sensor.maxAlarm) {
          sensor.color = Colors.green;
          sensor.icon = EvaIcons.checkmarkCircle2Outline;
        } else {
          sensor.color = Colors.red;
          sensor.icon = EvaIcons.bellOutline;
        }
      }
    }
  }

  downloadData(String sn, String start, String end) async {
    // try {
    //   final response = await _dio.get(
    //     '/Datums/DataByDate?DeviceSerialNumber=$sn&StartDate=$start&EndDate=$end',
    //     options: Options(
    //       headers: {
    //         "Content-Type": "application/json",
    //         "Authorization":
    //             "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
    //       },
    //     ),
    //   );
    //   final _base64 = base64Encode(response.data.toString().codeUnits);
    //   // Create the link with the file
    //   final anchor = html.AnchorElement(
    //       href: 'data:application/octet-stream;base64,$_base64')
    //     ..target = 'blank';
    //   // add the name
    //   anchor.download = '${sn}_${start}_$end.csv';

    //   // trigger download
    //   html.document.body!.append(anchor);
    //   anchor.click();
    //   anchor.remove();
    // } catch (e) {
    //   debugPrint("Download error " + e.toString());
    // }
  }

  // End
}
