import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/theme/app_colors.dart';

class DevicePage extends GetWidget<HomeController> {
  const DevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.detailDevice[0].friendlyName),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kGradient),
        ),
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
              Obx(
                () => Container(
                  width: 310,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (c, i) => SmartpHSensor(
                      sensor: controller.detailDevice[0].sensors[i],
                      isSetting: true,
                    ),
                    itemCount: controller.detailDevice[0].sensors.length,
                  ),
                ),
              ),
              DividerWithText(text: 'dataHistory'.tr),
              HistoryWidget(sensors: controller.detailDevice[0].sensors),
              const SizedBox(height: 20),
              _deviceInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceInfo() {
    return Column(
      children: [
        DividerWithText(
          text: "deviceInfo".tr,
        ),
        ListTile(
          title: Text(
            controller.detailDevice[0].friendlyName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 6),
        ListTile(
          title: Text("model".tr),
          trailing: Text(
            controller.detailDevice[0].model,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 6),
        ListTile(
          title: Text("serialNumber".tr),
          trailing: Text(
            controller.detailDevice[0].key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 6),
        ListTile(
          title: Text("description".tr),
          subtitle: Text(controller.detailDevice[0].description),
          isThreeLine: true,
        ),
        const Divider(height: 6),
      ],
    );
  }

  // End class
}
