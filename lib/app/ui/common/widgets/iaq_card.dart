import 'package:flutter/material.dart';
import 'package:phuonghai/app/data/models/iaq.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:get/get.dart';

import 'header_card.dart';
import 'header_modal.dart';

class IaqCard extends StatelessWidget {
  const IaqCard({Key? key, required this.model}) : super(key: key);
  final IaqModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderCard(model: model),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Obx(
            () => model.isActived.value
                ? IaqWidget(model: model)
                : SizedBox(
                    height: 120,
                    width: double.infinity,
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
          ),
        ),
      ],
    );
  }
}

class IaqWidget extends StatelessWidget {
  final IaqModel model;
  const IaqWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return model.sensors.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: WebsafeSvg.asset(
                          'assets/icons/${model.iaqStatus}.svg',
                          height: 90,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 360),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      HeaderModal(
                                          title: "${'airQuality'.tr} IAQ"),
                                      const IaqHelperItem(
                                        svg: 'Excellent',
                                        color: Colors.green,
                                        index: '61-65',
                                        text: 'Chất lượng không khí sạch',
                                      ),
                                      const Divider(),
                                      const IaqHelperItem(
                                        svg: 'Good',
                                        color: Colors.lightGreen,
                                        index: '52-60',
                                        text: 'Chất lượng không khí tốt',
                                      ),
                                      const Divider(),
                                      const IaqHelperItem(
                                        svg: 'Moderate',
                                        color: Colors.yellow,
                                        index: '39-51',
                                        text:
                                            'Chất lượng không khí trung bình ở mức chấp nhận được.\nKhông khuyến khi tiếp xúc trên 12 tháng.',
                                      ),
                                      const Divider(),
                                      const IaqHelperItem(
                                        svg: 'Poor',
                                        color: Colors.orange,
                                        index: '26-38',
                                        text:
                                            'Chất lượng không khí kém.\nẢnh hưởng đáng kể tới sự thoải mái.\nKhông khuyến khi tiếp xúc trên 1 tháng.',
                                      ),
                                      const Divider(),
                                      const IaqHelperItem(
                                        svg: 'Unhealthy',
                                        color: Colors.red,
                                        index: '0-25',
                                        text:
                                            'Chất lượng không khí không lành mạnh.\nKhông khuyến khích tiếp xúc',
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
                    ],
                  ),
                ),
                for (var i in model.sensors) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IaqSensorItem(sensor: i),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  )
                ]
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
      height: 42,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        children: [
          Obx(
            () => PhysicalModel(
              elevation: 1,
              color: sensor.color.value,
              shape: BoxShape.circle,
              child: const SizedBox(
                width: 18,
                height: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 85,
            child: Text(
              sensor.name.tr,
              style: TextStyle(
                color: sensor.status.toLowerCase() == "error"
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => Text(
                "${sensor.val.value}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: sensor.status.toLowerCase() == "error"
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
          ),
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    sensor.unit,
                    style: TextStyle(
                      color: sensor.status.toLowerCase() == "error"
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 75,
                  child: Text(
                    "${sensor.status.toLowerCase()}Iaq".tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: sensor.status.toLowerCase() == "error"
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class IaqHelperItem extends StatelessWidget {
  final String svg;
  final String text;
  final String index;
  final Color color;

  const IaqHelperItem({
    Key? key,
    required this.svg,
    required this.text,
    required this.color,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Container(
          width: 86,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${svg.toLowerCase()}Iaq".tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              WebsafeSvg.asset('assets/icons/$svg.svg', height: 50),
              Text(index),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Flexible(child: Text(text)),
      ],
    );
  }
}
