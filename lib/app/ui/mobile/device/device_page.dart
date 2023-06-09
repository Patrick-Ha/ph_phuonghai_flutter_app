import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/device.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';

import 'device_info.dart';

class SmartpHDevicePage extends StatefulWidget {
  const SmartpHDevicePage({Key? key, required this.model}) : super(key: key);
  final DeviceModel model;

  @override
  State<SmartpHDevicePage> createState() => _SmartpHDevicePageState();
}

class _SmartpHDevicePageState extends State<SmartpHDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.friendlyName)),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Obx(
                () => DividerWithText(
                  text: "${"lastUpdated".tr}: ${widget.model.getSyncDateObs}",
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 20,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    if (widget.model.sensors[i].name == ' FTP') {
                      return FTPConnection(sensor: widget.model.sensors[i]);
                    }
                    return SmartpHSensor(
                      sensor: widget.model.sensors[i],
                      isSetting: true,
                    );
                  },
                  itemCount: widget.model.sensors.length,
                ),
              ),
              DividerWithText(text: 'dataHistory'.tr),
              NewWidget(widget: widget),
              const SizedBox(height: 10),
              DeviceInfo(model: widget.model),
            ],
          ),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final SmartpHDevicePage widget;

  @override
  Widget build(BuildContext context) {
    final l = widget.model.sensors.skipWhile((value) => value.name == ' FTP');
    return HistoryWidget(sensors: l.toList());
  }
}
