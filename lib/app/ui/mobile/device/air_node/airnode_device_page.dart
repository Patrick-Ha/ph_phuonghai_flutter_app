import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/iaq.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/common/widgets/iaq_card.dart';
import 'package:phuonghai/app/ui/mobile/device/device_info.dart';

class AirNodeDevicePage extends StatelessWidget {
  const AirNodeDevicePage({Key? key, required this.model}) : super(key: key);
  final IaqModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.friendlyName),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Obx(
                () => DividerWithText(
                  text: "${"lastUpdated".tr}: ${model.getSyncDateObs}",
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: IaqWidget(model: model),
              ),
              DividerWithText(text: 'dataHistory'.tr),
              HistoryWidget(sensors: model.sensors),
              const SizedBox(height: 20),
              DeviceInfo(model: model),
            ],
          ),
        ),
      ),
    );
  }
}
