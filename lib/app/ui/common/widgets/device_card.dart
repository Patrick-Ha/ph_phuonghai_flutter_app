import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final DeviceModel model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              final c = Get.find<HomeController>();
              c.addDetailDevice(model);
              Get.toNamed(Routes.DEVICE);
            },
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    model.friendlyName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "#${model.key}",
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "${"lastUpdated".tr}: ${model.getSyncDate}",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (c, i) => SmartpHSensor(sensor: model.sensors[i]),
              itemCount: model.sensors.length,
            ),
          ),
        ],
      ),
    );
  }
}

class SmartpHSensor extends StatelessWidget {
  const SmartpHSensor({
    Key? key,
    required this.sensor,
    this.isSetting = false,
  }) : super(key: key);

  final SensorModel sensor;
  final bool isSetting;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: sensor.color == Colors.red
                ? Colors.red.withOpacity(0.5)
                : Colors.black12,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            sensor.icon,
            size: 22,
            color: sensor.color,
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: 80,
            child: Text(
              sensor.name.tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: sensor.status.toLowerCase() == "error"
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${sensor.value}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: sensor.status.toLowerCase() == "error"
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              sensor.unit,
              style: TextStyle(
                color: sensor.status.toLowerCase() == "error"
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              sensor.status.toLowerCase().tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: sensor.status.toLowerCase() == "error"
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          if (isSetting)
            IconButton(
              onPressed: () async {
                if (GetPlatform.isWeb) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(child: AlarmModal(sensor: sensor));
                    },
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    constraints: const BoxConstraints(maxWidth: 420),
                    builder: (context) {
                      return AlarmModal(sensor: sensor);
                    },
                  );
                }
              },
              splashRadius: 22,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.edit_notifications_outlined,
                color: Colors.blueGrey,
              ),
            ),
        ],
      ),
    );
  }
}

class AlarmModal extends StatefulWidget {
  const AlarmModal({Key? key, required this.sensor}) : super(key: key);

  final SensorModel sensor;
  @override
  State<AlarmModal> createState() => _AlarmModalState();
}

class _AlarmModalState extends State<AlarmModal> {
  @override
  void initState() {
    _value = widget.sensor.activeAlarm;
    if (widget.sensor.activeAlarm) {
      _minController.text = widget.sensor.minAlarm.toString();
      _maxController.text = widget.sensor.maxAlarm.toString();
    }

    super.initState();
  }

  @override
  dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  late bool _value;
  bool error = false;
  String status = "";
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: GetPlatform.isWeb ? 200 : 400,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          children: [
            ListTile(
              title: Text("notification".tr + " [${widget.sensor.name}]"),
              leading: Checkbox(
                value: _value,
                onChanged: (newValue) {
                  setState(() {
                    _minController.text = '';
                    _maxController.text = '';
                    _value = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: _value,
                    controller: _minController,
                    decoration: InputDecoration(
                      labelText: 'lowerThres'.tr,
                      prefixIcon: const Icon(Icons.align_vertical_bottom),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    enabled: _value,
                    controller: _maxController,
                    decoration: InputDecoration(
                      labelText: 'upperThres'.tr,
                      prefixIcon: const Icon(Icons.align_vertical_top),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Spacer(),
            DefaultButton(
              text: 'saveConfig'.tr,
              press: () {
                if (_value) {
                  bool err = false;
                  try {
                    final minValue = double.parse(_minController.text);
                    final maxValue = double.parse(_maxController.text);
                    if (minValue >= maxValue) {
                      err = true;
                    } else {
                      final c = Get.find<HomeController>();
                      widget.sensor.activeAlarm = true;
                      widget.sensor.minAlarm = minValue;
                      widget.sensor.maxAlarm = maxValue;
                      c.updateAlarmSensor(widget.sensor);
                    }
                  } catch (e) {
                    err = true;
                  }
                  if (err) {
                    Helper.showError("errorValue".tr);
                  } else {
                    Navigator.of(context).pop();
                    Helper.showSuccess("done".tr);
                  }
                } else {
                  final c = Get.find<HomeController>();
                  widget.sensor.activeAlarm = false;
                  c.updateAlarmSensor(widget.sensor);
                  Navigator.of(context).pop();
                  Helper.showSuccess("done".tr);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
