import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/common/widgets/iaq_card.dart';
import 'package:phuonghai/app/ui/theme/app_colors.dart';

class IaqPage extends GetWidget<HomeController> {
  const IaqPage({Key? key}) : super(key: key);

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
              const SizedBox(height: 10),
              Obx(
                () => IAQWidget(
                  model: controller.detailDevice[0],
                  fullBorder: true,
                ),
              ),
              const SizedBox(height: 10),
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
