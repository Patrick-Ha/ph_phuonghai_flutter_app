import 'package:flutter/material.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/iaq.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:get/get.dart';

class IaqCard extends StatelessWidget {
  const IaqCard({Key? key, required this.model}) : super(key: key);

  final IaqModel model;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          final controller = Get.find<HomeController>();
          controller.addDetailDevice(model);
          Get.toNamed(Routes.IAQ_DEVICE);
        },
        borderRadius: BorderRadius.circular(10),
        highlightColor: Colors.purple,
        splashColor: Colors.transparent,
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              decoration: BoxDecoration(
                color: model.sensors.isEmpty
                    ? Colors.white
                    : model.getColor.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.friendlyName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "${"lastUpdated".tr}: ${model.getSyncDate}",
                    style: const TextStyle(fontSize: 13.5),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
            IAQWidget(model: model),
          ],
        ),
      ),
    );
  }
}

class IAQWidget extends StatelessWidget {
  const IAQWidget({
    Key? key,
    required this.model,
    this.fullBorder = false,
  }) : super(key: key);

  final IaqModel model;
  final bool fullBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: model.sensors.isEmpty
            ? Colors.white
            : model.getColor.withOpacity(0.7),
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
          topLeft: fullBorder ? const Radius.circular(10) : Radius.zero,
          topRight: fullBorder ? const Radius.circular(10) : Radius.zero,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          model.sensors.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 5, right: 10),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "${model.iaqIndex}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: ' Greenlab IAQ',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      WebsafeSvg.asset(
                        'assets/icons/${model.iaqStatus}.svg',
                        height: 90,
                      ),
                      const SizedBox(height: 5),
                      Text("airQuality".tr),
                      const SizedBox(height: 2),
                      Text(
                        "${model.iaqStatus.toLowerCase()}Iaq".tr.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (c, i) => IaqSensorItem(sensor: model.sensors[i]),
              separatorBuilder: (c, i) => const SizedBox(height: 8),
              itemCount: model.sensors.length,
            ),
          ),
        ],
      ),
    );
  }
}

class IaqSensorItem extends StatelessWidget {
  const IaqSensorItem({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  final IaqSensor sensor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 8, right: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 65,
            child: Text(sensor.name.tr),
          ),
          VerticalDivider(
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: sensor.color,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              "${sensor.value}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 45,
            child: Text(
              sensor.unit,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
