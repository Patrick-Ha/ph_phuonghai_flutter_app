import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/enviro_chamber.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/desktop/dashboard/widgets/detail_device_web.dart';
import 'package:phuonghai/app/ui/mobile/device/device_info.dart';

class EnvironChamberPage extends StatefulWidget {
  const EnvironChamberPage({Key? key, required this.model}) : super(key: key);
  final EnviroChamberModel model;

  @override
  State<EnvironChamberPage> createState() => _EnvironChamberPageState();
}

class _EnvironChamberPageState extends State<EnvironChamberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.friendlyName)),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Obx(
                () => DividerWithText(
                  text: "${"lastUpdated".tr}: ${widget.model.getSyncDateObs}",
                ),
              ),
              const SizedBox(height: 5),
              StatusEnvironList(model: widget.model),
              const SizedBox(height: 15),
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
                    return SmartpHSensor(
                      sensor: widget.model.sensors[i],
                      isSetting: true,
                    );
                  },
                  itemCount: widget.model.sensors.length,
                ),
              ),
              DividerWithText(text: 'dataHistory'.tr),
              const SizedBox(height: 10),
              HistoryWidget(sensors: widget.model.sensors),
              const SizedBox(height: 10),
              DeviceInfo(model: widget.model),
            ],
          ),
        ),
      ),
    );
  }
}
