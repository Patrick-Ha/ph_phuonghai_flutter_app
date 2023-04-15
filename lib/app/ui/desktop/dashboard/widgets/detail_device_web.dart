import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/history_widget.dart';
import 'package:phuonghai/app/ui/common/widgets/iaq_card.dart';
import 'package:phuonghai/app/ui/common/widgets/refri_item_widget.dart';
import 'package:phuonghai/app/ui/mobile/device/device_info.dart';

import 'environ_card_web.dart';

class DetailDeviceWeb extends GetWidget<HomeController> {
  const DetailDeviceWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      child: Container(
        width: 450,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            left: BorderSide(
              color: Colors.black54,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 56,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.green.shade400,
                    Colors.indigo.shade400,
                  ],
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.detailDevice[0].friendlyName,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.visible.value = false;
                      controller.detailDevice[0].isSelected.value = false;
                    },
                    splashRadius: 22,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: [
                  Obx(
                    () => DividerWithText(
                      text:
                          "${"lastUpdated".tr}: ${controller.detailDevice[0].getSyncDateObs}",
                    ),
                  ),
                  if (controller.detailDevice[0].type == 'Refrigerator')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: RefriItemWidget(
                        sensor: controller.detailDevice[0].sensor,
                        isSetting: true,
                      ),
                    )
                  else if (controller.detailDevice[0].type == 'Air Node')
                    IaqWidget(model: controller.detailDevice[0])
                  else
                    Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 5,
                        right: 8,
                        bottom: 20,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (co, i) => SmartpHSensor(
                          sensor: controller.detailDevice[0].sensors[i],
                          isSetting: true,
                        ),
                        itemCount: controller.detailDevice[0].sensors.length,
                      ),
                    ),
                  DividerWithText(text: 'dataHistory'.tr),
                  if (controller.detailDevice[0].type == 'Refrigerator')
                    HistoryWidget(sensors: [
                      controller.detailDevice[0].sensor.temp,
                      controller.detailDevice[0].sensor.pin,
                    ])
                  else
                    HistoryWidget(sensors: controller.detailDevice[0].sensors),
                  const SizedBox(height: 15),
                  DeviceInfo(model: controller.detailDevice[0]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
