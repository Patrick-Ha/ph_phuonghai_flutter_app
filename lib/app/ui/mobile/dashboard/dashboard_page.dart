import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/iaq_card.dart';

import 'widgets/group_bottom_modal.dart';
import 'widgets/search_modal.dart';

class DashboardPage extends GetWidget<HomeController> {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            minimumSize: const Size(160, 38),
            primary: Colors.white,
          ),
          icon: const Icon(
            EvaIcons.chevronDown,
            color: Colors.yellow,
          ),
          label: Obx(() => Text(controller.selectedGroup.name.tr)),
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
        actions: [
          Obx(
            () => controller.isLoading.value
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.white,
                      size: 18,
                      secondRingColor: Colors.purple,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          IconButton(
            splashRadius: 22,
            icon: const Icon(EvaIcons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                constraints: const BoxConstraints(maxWidth: 420),
                builder: (context) {
                  return const SearchModal();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.selectedGroup.devices.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.browser_not_supported_outlined),
                  const SizedBox(width: 10),
                  Text(
                    "noDevice".tr,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                if (controller.selectedGroup.devices[index].type ==
                    "Air Node") {
                  return IaqCard(
                      model: controller.selectedGroup.devices[index]);
                } else {
                  return DeviceCard(
                      model: controller.selectedGroup.devices[index]);
                }
              },
              itemCount: controller.listGroup.value[0].devices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
            );
          }
        },
      ),
    );
  }
}
