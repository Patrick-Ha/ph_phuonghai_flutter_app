import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/mobile/device/air_node/airnode_device_page.dart';
import 'package:phuonghai/app/ui/mobile/device/device_page.dart';
import 'package:phuonghai/app/ui/mobile/device/refri_device/refri_device_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeaderCard extends StatelessWidget {
  HeaderCard({Key? key, required this.model}) : super(key: key);
  final dynamic model;
  final hover = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        onHover: (value) => hover.value = value,
        onTap: () {
          if (!GetPlatform.isWeb && Get.width < 600) {
            if (model.type == "Air Node") {
              Get.to(() => AirNodeDevicePage(model: model));
            } else if (model.type == 'Refrigerator') {
              Get.to(() => RefiDevicePage(model: model));
            } else {
              Get.to(() => SmartpHDevicePage(model: model));
            }
          } else {
            final c = Get.find<HomeController>();
            c.addDetailDevice(model);
          }
        },
        child: Material(
          color: model.isSelected.value && GetPlatform.isWeb && Get.width > 600
              ? Colors.amber.shade100
              : Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.friendlyName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        "#${model.key}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 1),
                      Obx(
                        () => Text(
                            "${"lastUpdated".tr}: ${timeago.format(model.dateSyncObs.value, locale: Get.locale?.languageCode)}"),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Icon(
                    Icons.keyboard_arrow_right,
                    color: hover.value ? Colors.amber : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
