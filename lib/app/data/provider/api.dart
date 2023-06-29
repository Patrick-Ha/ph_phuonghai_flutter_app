import 'dart:convert';
import 'package:flutter_excel/excel.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phuonghai/app/data/models/enviro_chamber.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/data/models/iaq.dart';
import 'package:phuonghai/app/data/models/refrigerator.dart';
import 'package:phuonghai/app/data/models/user.dart';

import '../models/device.dart';

const baseUrl = 'http://thegreenlab.xyz:3000';

class ApiClient {
  final UserModel user;
  final Dio dio;
  final List<DeviceModel> devices = [];
  final users = [].obs;
  final devicesDisplay = [].obs;
  final devicesByUser = [].obs;

  int greenlabCnt = 0;
  int smartphCnt = 0;
  int othersCnt = 0;

  ApiClient({required this.user, required this.dio});

  // Fetch all device by User
  Future<List> fetchUserDevices() async {
    final dList = [];

    try {
      final response = await dio.get('/Devices/ByUser');
      for (var element in response.data) {
        late final dynamic d;

        if (element['Type'] == 'Air Node') {
          d = IaqModel.fromJson(element);
        } else if (element['Type'] == 'Refrigerator') {
          d = Refrigerator.fromJson(element);
          d.sensor.key = d.key;
          d.sensor.temp.key = d.key;
          d.sensor.pin.key = d.key;
          final ref = element['Sensors'].firstWhere(
            (element) => element['SensorType'] == 'Temp',
          );
          d.sensor.temp.id = ref['Id'];
          d.sensor.temp.setAlarm(ref['MinValue'], ref['MaxValue']);
        } else if (element['Type'] == 'Environmental Chamber') {
          d = EnviroChamberModel.fromJson(element);
        } else {
          d = DeviceModel.fromJson(element);
          d.sensorsRef.addAll(element['Sensors']);
        }
        d.dateTimeSync = element['DateSync'];
        dList.add(d);
      }
    } catch (e) {
      debugPrint("Device info: $e");
    }

    return dList;
  }

  Future<List<GroupModel>> getAllGroupOfUser(List allDe) async {
    final gList = <GroupModel>[];

    try {
      final response = await dio.get("/UserDevicegroup");
      if (response.data.isEmpty) {
        // Chua co Group => Tao group => Dua het thiet bi so huu vao
        final id = await createGroup('allDevices'.tr, 1, 'allDevices'.tr);
        if (id != 0) {
          for (int i = 0; i < allDe.length; i++) {
            await addDeviceToGroup(id, allDe[i].id);
          }
        }
      } else {
        for (final g in response.data) {
          final group = GroupModel.fromJson(g);
          group.name.value = g['Name'];
          gList.add(group);
        }
      }
    } catch (e) {
      debugPrint("Get group error ${e.toString()}");
    }

    return gList;
  }

  // Return list device
  //  {
  //     "Id": 22,
  //     "Orderno": 1,
  //     "Device": {
  //       "Id": 163,
  //       "DateSync": "2022-11-15T14:16:41.000Z",
  //       "Description": "Xử lý nước thải KCN Hạnh Phúc, Long An",
  //       "FriendlyName": "KCN Hạnh Phúc, Long An",
  //       "Model": "SmartpH-Log01",
  //       "SerialNumber": "Log01181212",
  //       "Type": "Datalogger",
  //     }
  //   }
  Future<List> getDeviceOfGroup(int idGroup) async {
    final list = [];
    try {
      final response = await dio.get("/UserDevicegroup/$idGroup");
      return response.data['Devices'];
    } catch (e) {
      debugPrint("[getDeviceOfGroup]: ${e.toString()}");
    }
    return list;
  }

  Future<int> createGroup(String name, int order, String des) async {
    try {
      final response = await dio.post(
        '/UserDevicegroup',
        data: {'Name': name, 'Description': des, 'Orderno': order},
      );
      return response.data["data"]["Id"];
    } catch (e) {
      debugPrint('Create group error ${e.toString()}');
    }
    return 0;
  }

  Future<void> addDeviceToGroup(int idGroup, int idDevice) async {
    try {
      await dio.post(
        '/UserDevicegroupDevice',
        data: {
          'Group': {"Id": idGroup},
          'Device': {"Id": idDevice},
          'Orderno': 1,
        },
      );
    } catch (e) {
      debugPrint('Create group error ${e.toString()}');
    }
  }

  Future<void> removeDeviceToGroup(int idInGroup) async {
    try {
      await dio.delete('/UserDevicegroupDevice/$idInGroup');
    } catch (e) {
      debugPrint('[removeDeviceToGroup] ${e.toString()}');
    }
  }

  Future<void> renameGroup(int id, String name) async {
    try {
      await dio.put(
        '/UserDevicegroup',
        data: {
          'Id': id,
          'Name': name,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteGroup(int id) async {
    try {
      await dio.delete('/UserDevicegroup/$id');
    } catch (e) {
      debugPrint("[deleteGroup]: ${e.toString()}");
    }
  }

  Future<void> getSensorOfDevice(dynamic device, bool isFirst) async {
    try {
      final response = await dio.get(
        "/Datums/LastestDataByDevice?DeviceSerialNumber=${device.key}",
      );

      if (response.data.isNotEmpty) {
        final lastest = response.data.reduce(
          (min, e) => DateTime.parse(e['ReceivedDate'])
                  .isAfter(DateTime.parse(min['ReceivedDate']))
              ? e
              : min,
        );

        response.data.removeWhere(
            (item) => item['ReceivedDate'] != lastest['ReceivedDate']);

        response.data.removeWhere((item) => item['Status'] == 'disabled');

        if (device.type == 'Refrigerator') {
          // Tu lanh di dong
          for (var i in response.data) {
            if (i['SensorType'] == 'Pin') {
              device.sensor.pin.val.value = i['Value'].toDouble();
              device.sensor.pin.status.value = i['Status'];
            } else if (i['SensorType'] == 'Temp') {
              device.sensor.temp.val.value = i['Value'].toDouble();
              device.sensor.temp.status.value = i['Status'];
              checkAlarm(device.sensor.temp);
            } else if (i['SensorType'] == 'Lat') {
              device.sensor.lat = i['Value'].toDouble();
              device.sensor.gpsState.value = i['Status'];
            } else if (i['SensorType'] == 'Long') {
              device.sensor.long = i['Value'].toDouble();
            } else if (i['SensorType'] == 'Lock') {
              device.sensor.lock.val.value = i['Value'].toDouble();
            }
          }
          device.sensor.processPinLock();
          device.sensor.timeUpdated = DateFormat('d-M-yyyy, HH:mm').format(
            DateTime.parse(response.data[0]["ReceivedDate"]).toLocal(),
          );

          if (device.markers.isEmpty) {
            // device.markers.add(
            //   Marker(
            //     key: Key(device.sensor.timeUpdated),
            //     point: LatLng(device.sensor.lat, device.sensor.long),
            //     width: 26,
            //     height: 26,
            //     builder: (_) => AvatarGlow(
            //       child: Icon(
            //         Icons.radio_button_checked,
            //         size: 20,
            //         color: device.sensor.gpsState.value == 'Good'
            //             ? Colors.blue
            //             : Colors.red,
            //       ),
            //       endRadius: 22,
            //       glowColor: device.sensor.gpsState.value == 'Good'
            //           ? Colors.blueAccent
            //           : Colors.redAccent,
            //     ),
            //   ),
            // );
          } else {
            if (device.markers.first.key != Key(device.sensor.timeUpdated)) {
              // device.markers.first = Marker(
              //   key: Key(device.sensor.timeUpdated),
              //   point: LatLng(device.sensor.lat, device.sensor.long),
              //   width: 26,
              //   height: 26,
              //   builder: (_) => AvatarGlow(
              //     child: Icon(
              //       Icons.radio_button_checked,
              //       size: 20,
              //       color: device.sensor.gpsState.value == 'Good'
              //           ? Colors.blue
              //           : Colors.red,
              //     ),
              //     endRadius: 22,
              //     glowColor: device.sensor.gpsState.value == 'Good'
              //         ? Colors.blueAccent
              //         : Colors.redAccent,
              //   ),
              // );
            }
          }
        } else if (device.type == "Environmental Chamber") {
          // Tu moi truong
          for (var i in response.data) {
            switch (i['SensorType']) {
              case 'operation':
                device.operation.value = i['Status'];
                device.countTimer.value = i['Value'].toInt();
                break;
              case 'mode':
                device.mode.value = i['Status'];
                break;
              case 'heater':
                device.heater.value = i['Value'].toInt();
                break;
              case 'cooler':
                device.cooler.value = i['Value'].toInt();
                break;
              case 'humidity':
                device.humidity.value = i['Value'].toInt();
                break;
              case 'moise':
                device.moise.value = i['Value'].toInt();
                break;
              case 'temp_now':
                device.tempNow.value = i['Value'].toDouble();
                if (isFirst) {
                  final sensor = SensorModel.fromJson(device.key, i);
                  sensor.val.value = i['Value'].toDouble();
                  sensor.status.value = i['Status'];
                  sensor.setAlarm(i['MinValue'], i['MaxValue']);
                  checkAlarm(sensor);
                  device.sensors.add(sensor);
                }
                break;
              case 'temp_set':
                device.tempSet.value = i['Value'].toDouble();
                break;
              case 'hum_now':
                device.humNow.value = i['Value'].toDouble();
                if (isFirst) {
                  final sensor = SensorModel.fromJson(device.key, i);
                  sensor.val.value = i['Value'].toDouble();
                  sensor.status.value = i['Status'];
                  sensor.setAlarm(i['MinValue'], i['MaxValue']);
                  checkAlarm(sensor);
                  device.sensors.add(sensor);
                }
                break;
              case 'hum_set':
                device.humSet.value = i['Value'].toDouble();
                break;
              default:
                break;
            }
          }
        } else {
          // Cac thiet bi khac
          for (var i in response.data) {
            if (isFirst) {
              if (device.type == 'Air Node') {
                if (i["SensorType"] == "IAQ") {
                  device.iaqIndex.value = i["Value"].toInt();
                  device.iaqStatus = i["Status"];
                } else {
                  final sensor = IaqSensor.fromJson(device.key, i);
                  sensor.val.value = i['Value'].toDouble();
                  sensor.status.value = i['Status'];
                  sensor.setColor = i['Status'];
                  device.sensors.add(sensor);
                }
              } else {
                final sensor = SensorModel.fromJson(device.key, i);
                final refIndex = device.sensorsRef.indexWhere(
                  (element) => element['SensorType'] == sensor.name,
                );
                if (refIndex != -1) {
                  final ref = device.sensorsRef.removeAt(refIndex);
                  sensor.id = ref['Id'];
                  sensor.setAlarm(ref['MinValue'], ref['MaxValue']);
                  sensor.val.value = i['Value'].toDouble();
                  sensor.status.value = i['Status'];
                  checkAlarm(sensor);
                  device.sensors.add(sensor);
                }
              }
            } else {
              final index = device.sensors
                  .indexWhere((element) => element.name == i['SensorType']);
              if (index != -1) {
                device.sensors[index].status.value = i["Status"];
                device.sensors[index].val.value = i["Value"].toDouble();
                if (device.type == "Air Node") {
                  device.sensors[index].setColor = i['Status'];
                } else {
                  checkAlarm(device.sensors[index]);
                }
              }
            }
          }
        }

        final timeSync =
            DateTime.parse(response.data[0]["ReceivedDate"]).toLocal();
        if (timeSync.isAfter(device.dateSyncObs.value)) {
          device.dateTimeSync = timeSync.toString();
        }

        if (DateTime.now().difference(device.dateSyncObs.value).inHours > 3) {
          device.isActived.value = false;
        } else {
          device.isActived.value = true;
        }
      }
    } catch (e) {
      debugPrint("getSensorOfDevice: $e");
    }
  }

  checkAlarm(SensorModel sensor) {
    // Kiem tra Alarm
    if (sensor.status.toLowerCase() == "error") {
      sensor.color.value = Colors.amber;
      sensor.icon = Icons.report;
    } else if (sensor.status.toLowerCase() == "calibrating") {
      sensor.color.value = Colors.blueGrey;
      sensor.icon = Icons.pending_outlined;
    } else {
      if (sensor.activeAlarm == 0) {
        sensor.color.value = Colors.blueGrey;
        sensor.icon = Icons.check_circle;
      } else if (sensor.activeAlarm == 1) {
        // Gia tri an toan ben trong
        if (sensor.minAlarm <= sensor.val.value &&
            sensor.val.value <= sensor.maxAlarm) {
          sensor.color.value = Colors.green;
          sensor.icon = Icons.check_circle;
        } else {
          sensor.color.value = Colors.red;
          sensor.icon = Icons.notifications_active;
        }
      } else {
        // Gia tri an toan ben ngoai
        if (sensor.val.value <= sensor.minAlarm ||
            sensor.val.value >= sensor.maxAlarm) {
          sensor.color.value = Colors.green;
          sensor.icon = Icons.check_circle;
        } else {
          sensor.color.value = Colors.red;
          sensor.icon = Icons.notifications_active;
        }
      }
    }
  }

  Future<bool> deleteAccountByUser(String pwd) async {
    final token = "Basic ${base64.encode(utf8.encode("${user.email}:$pwd"))}";
    if (token == user.token) {
      try {
        await dio.delete(
          '/Users/${user.id}',
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
            },
          ),
        );
      } catch (e) {
        debugPrint("delete account: $e");
        return false;
      }
      return true;
    }
    return false;
  }

  Future<bool> deleteAccountByAdmin(int id) async {
    try {
      await dio.delete(
        '/Users/$id',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );
      return true;
    } catch (e) {
      debugPrint("delete account: $e");
      return false;
    }
  }

  Future<bool> downloadData(String sn, String start, String end) async {
    try {
      final response = await dio.get(
        '/Datums/DataByDateJson?DeviceSerialNumber=$sn&StartDate=$start&EndDate=$end',
      );

      List<String> sensors = ['Time'];
      List<List<String>> dateList = [];
      List<List<num>> dataCsv = [];
      int index = -1;
      for (var element in response.data) {
        if (sensors.contains('${element['SensorType']} (${element['Unit']})') ==
            false) {
          sensors.add('${element['SensorType']} (${element['Unit']})');
          index++;
          dataCsv.add([]);
          dateList.add([]);
        }
        dataCsv[index].add(element['Value']);
        dateList[index].add(element['Date']);
      }

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      for (var t = 0; t < sensors.length; t++) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: t))
          ..value = sensors[t]
          ..cellStyle = CellStyle(
            bold: true,
            verticalAlign: VerticalAlign.Center,
            horizontalAlign: HorizontalAlign.Center,
          );
      }

      // Write time
      for (var i = 0; i < dateList[0].length; i++) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(rowIndex: i + 1, columnIndex: 0))
          ..value = dateList[0][i]
          ..cellStyle = CellStyle(
            verticalAlign: VerticalAlign.Center,
            horizontalAlign: HorizontalAlign.Center,
          );
      }

      // Write data
      for (var col = 0; col < dataCsv.length; col++) {
        for (var row = 0; row < dataCsv[col].length; row++) {
          sheetObject.cell(CellIndex.indexByColumnRow(
              rowIndex: row + 1, columnIndex: col + 1))
            ..value = dataCsv[col][row]
            ..cellStyle = CellStyle(
              verticalAlign: VerticalAlign.Center,
              horizontalAlign: HorizontalAlign.Center,
            );
        }
      }
      excel.save(fileName: "${sn}_${start}_$end.xlsx");
      return true;
    } catch (e) {
      debugPrint("Download error $e");
      return false;
    }
  }

  Future<bool> createAccount(String email, String pwd) async {
    try {
      final response = await dio.post(
        '/Users/Auth/Register',
        data: {'Email': email, 'Password': pwd},
      );

      if (response.data.containsKey('message')) {
        return false;
      } else {
        final user = UserModel.fromJson(response.data);
        users.add(user);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> getAllUsers() async {
    try {
      final resp = await dio.get(
        '/Users/find/.com',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );
      for (var element in resp.data) {
        final user = UserModel.fromJson(element);
        users.add(user);
      }
    } catch (e) {
      debugPrint("[Get all user] $e");
    }
  }

  Future<void> getAllDevices() async {
    try {
      final resp = await dio.get(
        '/Devices',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );
      for (var element in resp.data) {
        final device = DeviceModel.fromJson(element);
        devices.add(device);
        devicesDisplay.add(device);
      }
      greenlabCnt = devices.where((c) => c.type.contains('Hood')).length;
      smartphCnt = devices.where((c) => c.model == 'SmartpH-Log01').length;
      othersCnt = devices.length - greenlabCnt - smartphCnt;
    } catch (e) {
      debugPrint("[Get all user] $e");
    }
  }

  Future<void> getDeviceByIdUser(int id) async {
    devicesByUser.clear();
    try {
      final resp = await dio.get(
        '/Users/$id/Devices',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );
      for (var element in resp.data) {
        final device = DeviceModel.fromJson(element);
        devicesByUser.add(device);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> assignDeviceToUser(int userId) async {
    final dataList = [];
    for (var element in devicesByUser) {
      final e = {
        "User": {"Id": userId.toString()},
        "Device": {"Id": element.id.toString()},
        "DeviceSerialNumber": element.key,
        "DeviceId": element.id.toString(),
      };
      dataList.add(e);
    }

    try {
      final resp = await dio.post(
        '/UserDevices/Assign',
        data: jsonEncode(dataList),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );

      if (resp.data['Status'] == 'OK') {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return false;
  }

  Future<bool> deleteDevice(int id) async {
    // try {
    //   final resp = await dio.delete(
    //     '/Devices/{$id}',
    //     options: Options(
    //       headers: {
    //         "Content-Type": "application/json",
    //         "Authorization":
    //             "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
    //       },
    //     ),
    //   );
    //   // if (resp.statusCode == 201) {
    //   //   final device = DeviceModel.fromJson(resp.data);
    //   //   devices.add(device);
    //   //   return true;
    //   // }
    // } catch (e) {
    //   debugPrint(e.toString());
    //   return false;
    // }
    return false;
  }

  editAlarmSensor(int id, num? minValue, num? maxValue) async {
    try {
      await dio.put(
        '/Sensors',
        data: {
          'Id': id,
          'MinValue': minValue,
          'MaxValue': maxValue,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> editDevice(
      int id, String name, String model, String type, String desp) async {
    try {
      final resp = await dio.put(
        '/Devices',
        data: {
          'Id': id,
          'FriendlyName': name,
          'Model': model,
          'Type': type,
          'Description': desp,
          "IsActive": true,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );
      if (resp.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> editCamUrl(int idDEvice, int idCam, String url) async {
    try {
      final resp = await dio.put(
        '/Devices',
        data: {
          'Id': idDEvice,
          'camUrl$idCam': url,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );
      if (resp.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> createDevice(String name, String type, String model, String sn,
      String date, String desp) async {
    // Kiem tra da co so SN chua
    final contain = devices.indexWhere((p0) => p0.key == sn);
    if (contain != -1) {
      return false;
    }

    try {
      final resp = await dio.post(
        '/Devices',
        data: {
          'FriendlyName': name,
          'Type': type,
          'Model': model,
          'SerialNumber': sn,
          'Description': desp,
          'DateSync': date,
          "Lab_Id": null,
          "LabSerialNumber": "",
          "IsActive": 0,
          "Devicegroup_Id2": 0
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Basic ZHJhZ29ubW91bnRhaW4ucHJvamVjdEBnbWFpbC5jb206TG9uZ1Nvbn5e",
          },
        ),
      );

      if (resp.statusCode == 201) {
        final device = DeviceModel.fromJson(resp.data);
        devices.add(device);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return false;
  }

  // End
}
