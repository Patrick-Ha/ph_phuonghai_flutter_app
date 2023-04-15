import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/common/widgets/iaq_card.dart';

import 'device_info.dart';

class IaqPage extends GetWidget<HomeController> {
  const IaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.detailDevice[0].friendlyName),
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
                  text:
                      "${"lastUpdated".tr}: ${controller.detailDevice[0].getSyncDate}",
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => IaqWidget(model: controller.detailDevice[0]),
              ),
              const SizedBox(height: 10),
              DividerWithText(text: 'dataHistory'.tr),
              HistoryWidget(sensors: controller.detailDevice[0].sensors),
              const SizedBox(height: 20),
              DeviceInfo(model: controller.detailDevice[0]),
            ],
          ),
        ),
      ),
    );
  }

  // End class
}
