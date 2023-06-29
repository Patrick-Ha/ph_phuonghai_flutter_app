import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/enviro_chamber.dart';
import 'package:phuonghai/app/ui/common/widgets/header_card.dart';

class EnvironCard extends StatelessWidget {
  const EnvironCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final EnviroChamberModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderCard(model: model),
        Obx(
          () => model.isActived.value
              ? Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(width: 5),
                      Row(
                        children: [
                          const SizedBox(width: 6),
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              minLeadingWidth: 20,
                              leading: const SizedBox(
                                  height: double.infinity,
                                  child: Icon(Icons.monitor_heart)),
                              subtitle: Obx(() => Text(
                                    model.operation.value.tr,
                                    style: TextStyle(
                                      color: model.operation.value == 'stop'
                                          ? null
                                          : Colors.orange,
                                    ),
                                  )),
                              title: Text('deviceInfo'.tr),
                            ),
                          ),
                          const SizedBox(height: 35, child: VerticalDivider()),
                          Expanded(
                            child: ListTile(
                              minLeadingWidth: 12,
                              leading: const Icon(Icons.timelapse),
                              title: Obx(() => Text(
                                  '${(Duration(seconds: model.countTimer.value))}'
                                      .substring(0, 4)
                                      .padLeft(5, '0'))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() => Icon(
                                        Icons.waves,
                                        color: model.heater.value == 1
                                            ? Colors.orange
                                            : null,
                                      )),
                                  const SizedBox(height: 2),
                                  Obx(() => Text(
                                        'heater'.tr,
                                        style: TextStyle(
                                          color: model.heater.value == 1
                                              ? Colors.orange
                                              : null,
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                                width: 30,
                                child: Divider(),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() => Icon(
                                        Icons.ac_unit,
                                        color: model.cooler.value == 1
                                            ? Colors.orange
                                            : null,
                                      )),
                                  const SizedBox(height: 2),
                                  Obx(() => Text(
                                        'cooler'.tr,
                                        style: TextStyle(
                                          color: model.cooler.value == 1
                                              ? Colors.orange
                                              : null,
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                                width: 30,
                                child: Divider(),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() => Icon(
                                        Icons.invert_colors_off,
                                        color: model.humidity.value == 1
                                            ? Colors.orange
                                            : null,
                                      )),
                                  const SizedBox(height: 2),
                                  Obx(() => Text(
                                        'humiditier'.tr,
                                        style: TextStyle(
                                          color: model.humidity.value == 1
                                              ? Colors.orange
                                              : null,
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                                width: 30,
                                child: Divider(),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() => Icon(
                                        Icons.invert_colors,
                                        color: model.moise.value == 1
                                            ? Colors.orange
                                            : null,
                                      )),
                                  const SizedBox(height: 2),
                                  Obx(() => Text(
                                        'moiser'.tr,
                                        style: TextStyle(
                                          color: model.moise.value == 1
                                              ? Colors.orange
                                              : null,
                                        ),
                                      ))
                                ],
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Card(
                                color: Colors.grey.shade100,
                                child: SizedBox(
                                  width: kIsWeb ? 280 : 260,
                                  height: 100,
                                  child: Center(
                                    child: ListTile(
                                      minLeadingWidth: 20,
                                      leading: const SizedBox(
                                        height: double.infinity,
                                        child: Icon(Icons.thermostat),
                                      ),
                                      title: Text('Temperature'.tr),
                                      subtitle: Obx(
                                        () => model.tempSet.value == 0
                                            ? Text("${'set'.tr}: ----")
                                            : Text(
                                                "${'set'.tr}: ${model.tempSet} °C"),
                                      ),
                                      trailing: Obx(
                                        () => Text(
                                          '${model.tempNow} °C',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Card(
                                color: Colors.grey.shade100,
                                child: SizedBox(
                                  width: kIsWeb ? 280 : 260,
                                  height: 100,
                                  child: Center(
                                    child: ListTile(
                                      minLeadingWidth: 20,
                                      leading: const SizedBox(
                                        height: double.infinity,
                                        child: Icon(Icons.water_drop),
                                      ),
                                      title: Text('Humidity'.tr),
                                      subtitle: Obx(
                                        () => model.tempSet.value == 0
                                            ? Text("${'set'.tr}: ----")
                                            : Text(
                                                "${'set'.tr}: ${model.humSet} %"),
                                      ),
                                      trailing: Obx(
                                        () => Text(
                                          '${model.humNow} %',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
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
                        "${"lostConnection".tr}: ${model.getSyncDateObs}",
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
        )
      ],
    );
  }
}
