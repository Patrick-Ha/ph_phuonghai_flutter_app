import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/iaq_card.dart';
import 'package:phuonghai/app/ui/common/widgets/templog_card.dart';
import 'package:phuonghai/app/ui/mobile/device/refri_device/refrigerator_card_mobile.dart';
import 'package:phuonghai/app/ui/theme/app_colors.dart';

import 'widgets/group_bottom_modal.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.group}) : super(key: key);

  final GroupModel group;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            alignment: Alignment.centerLeft,
            minimumSize: const Size(160, 38),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.yellow,
          ),
          label: Obx(
            () => Text(widget.group.name.value),
          ),
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              constraints: const BoxConstraints(maxWidth: 420),
              builder: (context) {
                return GroupBottomModal();
              },
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: kGradient),
        child: Obx(
          () => widget.group.devices.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.browser_not_supported_outlined),
                    const SizedBox(width: 10),
                    Text(
                      "noDevice".tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              : Scrollbar(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      if (widget.group.devices[index].type == "Air Node") {
                        return IaqCard(
                          model: widget.group.devices[index],
                        );
                      } else if (widget.group.devices[index].type ==
                          "TempLog") {
                        return TempLogCard(model: widget.group.devices[index]);
                      } else if (widget.group.devices[index].type ==
                          "Refrigerator") {
                        return RefrigeratorCardMobile(
                            model: widget.group.devices[index]);
                      } else {
                        return DeviceCard(model: widget.group.devices[index]);
                      }
                    },
                    itemCount: widget.group.devices.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  ),
                ),
        ),
      ),
    );
  }
}
