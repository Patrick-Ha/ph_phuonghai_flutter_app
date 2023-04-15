import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/smartph_tips.dart';

import 'header_card.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final DeviceModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderCard(model: model),
        Obx(
          () => model.isActived.value
              ? Flexible(
                  child: Material(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        bottom: 12,
                      ),
                      color: Colors.transparent,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: GetPlatform.isWeb
                            ? null
                            : const NeverScrollableScrollPhysics(),
                        itemCount: model.sensors.length,
                        itemBuilder: (context, index) => SmartpHSensor(
                          sensor: model.sensors[index],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 120,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.report,
                        size: 50,
                        color: Colors.amber,
                      ),
                      Text(
                        "lostConnection".tr + ": " + model.getSyncDateObs,
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
        ),
      ],
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
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(child: SmartpHTips());
                },
              );
            },
            splashRadius: 16,
            hoverColor: Colors.black26,
            padding: EdgeInsets.zero,
            icon: Obx(
              () => AvatarGlow(
                repeatPauseDuration: const Duration(seconds: 5),
                animate: sensor.color.value == Colors.red ||
                        sensor.color.value == Colors.amber
                    ? true
                    : false,
                glowColor: sensor.color.value,
                child: Icon(
                  sensor.icon,
                  color: sensor.color.value,
                ),
                endRadius: 24,
              ),
            ),
          ),
          SizedBox(
            width: GetPlatform.isWeb ? 90 : 80,
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
            child: Obx(
              () => Text(
                "${sensor.val}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: sensor.status.toLowerCase() == "error"
                      ? Colors.grey
                      : Colors.black,
                ),
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
            child: Obx(
              () => Text(
                sensor.status.toLowerCase().tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: sensor.status.toLowerCase() == "error"
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
          ),
          if (isSetting)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(child: AlarmModal(sensor: sensor));
                  },
                );
              },
              splashRadius: 22,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.edit_notifications_outlined,
                color: Colors.blueGrey,
              ),
              tooltip: "settingThres".tr,
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initValue();
    });
  }

  @override
  dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  bool alarmActive = false;
  bool error = false;
  String status = "";
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final listMode = ['outThres'.tr, 'inThres'.tr];
  String dropdownValue = 'outThres'.tr;

  void initValue() {
    setState(() {
      alarmActive = widget.sensor.activeAlarm != 0;
      if (widget.sensor.activeAlarm != 0) {
        _minController.text = widget.sensor.minAlarm.toString();
        _maxController.text = widget.sensor.maxAlarm.toString();
        dropdownValue = listMode[widget.sensor.activeAlarm - 1];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
      child: Column(
        children: [
          ListTile(
            title: Text("notification".tr + " [${widget.sensor.name}]"),
            leading: Checkbox(
              value: alarmActive,
              onChanged: (newValue) {
                setState(() {
                  _minController.text = '';
                  _maxController.text = '';
                  alarmActive = newValue!;
                });
              },
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: alarmActive,
                  controller: _minController,
                  decoration: InputDecoration(
                    labelText: 'lowerThres'.tr,
                    prefixIcon: const Icon(
                      Icons.align_vertical_bottom,
                      color: Colors.pink,
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  enabled: alarmActive,
                  controller: _maxController,
                  decoration: InputDecoration(
                    labelText: 'upperThres'.tr,
                    prefixIcon: const Icon(
                      Icons.align_vertical_top,
                      color: Colors.blue,
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('modeThres'.tr),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: dropdownValue,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurple,
                      ),
                      onChanged: alarmActive
                          ? (String? value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            }
                          : null,
                      items: listMode
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(
                    Icons.circle,
                    size: 14,
                  ),
                  minLeadingWidth: 10,
                  title: Text('hintThresOut'.tr),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.circle,
                    size: 14,
                  ),
                  minLeadingWidth: 10,
                  title: Text('hintThresIn'.tr),
                ),
              ],
            ),
          ),
          DefaultButton(
            text: 'saveConfig'.tr,
            press: () {
              if (alarmActive) {
                bool err = false;
                try {
                  final minValue = num.parse(_minController.text);
                  final maxValue = num.parse(_maxController.text);
                  if (minValue >= maxValue) {
                    err = true;
                  } else {
                    final c = Get.find<HomeController>();
                    dropdownValue == 'outThres'.tr
                        ? widget.sensor.activeAlarm = 1
                        : widget.sensor.activeAlarm = 2;
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
                }
              } else {
                final c = Get.find<HomeController>();
                widget.sensor.activeAlarm = 0;
                c.updateAlarmSensor(widget.sensor);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }
}
