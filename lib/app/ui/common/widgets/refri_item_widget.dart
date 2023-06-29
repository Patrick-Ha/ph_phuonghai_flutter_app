import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/refrigerator.dart';

import 'device_card.dart';
import 'smartph_tips.dart';

class RefriItemWidget extends StatelessWidget {
  const RefriItemWidget({
    Key? key,
    required this.sensor,
    this.isSetting = false,
  }) : super(key: key);

  final RefriItem sensor;
  final bool isSetting;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dialog(child: SmartpHTips());
                      },
                    );
                  },
                  splashRadius: 16,
                  hoverColor: Colors.black26,
                  padding: EdgeInsets.zero,
                  icon: Obx(
                    () => AvatarGlow(
                      repeatPauseDuration: const Duration(seconds: 5),
                      animate:
                          sensor.temp.color.value == Colors.red ? true : false,
                      glowColor: Colors.red,
                      endRadius: 24,
                      child: Icon(
                        sensor.temp.icon,
                        color: sensor.temp.color.value,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Text('${"Temp".tr}:'),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    '${sensor.temp.val.value} °C',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          if (isSetting)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(child: AlarmModal(sensor: sensor.temp));
                  },
                );
              },
              splashRadius: 22,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.edit_notifications_outlined,
                color: Colors.blueGrey,
              ),
              tooltip: "settingThres".tr,
            ),
          const VerticalDivider(
            color: Colors.black54,
            width: 26,
            indent: 6,
            endIndent: 6,
          ),
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                sensor.pin.status.value == 'Charging'
                    ? const Icon(
                        Icons.bolt,
                        size: 18,
                        color: Colors.orangeAccent,
                      )
                    : const SizedBox(width: 5),
                // BatteryIndicator(
                //   batteryFromPhone: false,
                //   batteryLevel: sensor.pin.val.value.toInt(),
                //   style: BatteryIndicatorStyle.skeumorphism,
                // ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          const VerticalDivider(
            color: Colors.black54,
            width: 26,
            indent: 6,
            endIndent: 6,
          ),
          Tooltip(
            message: 'Khóa nắp',
            child: Obx(
              () => Icon(
                sensor.lock.icon,
                size: 22,
                color: sensor.lock.color.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
