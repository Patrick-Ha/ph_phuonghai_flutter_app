import 'package:badges/badges.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_bottom_modal.dart';

import 'widgets/add_device_modal.dart';
import 'widgets/create_group_modal.dart';
import 'widgets/rename_modal.dart';

class GroupsPage extends GetWidget<HomeController> {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(160, 38),
            primary: Colors.white,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              constraints: const BoxConstraints(maxWidth: 420),
              builder: (context) {
                return const CreateGroupModal();
              },
            );
          },
          icon: const Icon(
            Icons.dashboard_customize_outlined,
            color: Colors.yellowAccent,
          ),
          label: Text("createGroup".tr),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.listGroup.value.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return GroupSettingsWidget(
                enable: false,
                group: controller.listGroup.value[0],
              );
            } else {
              return GroupSettingsWidget(
                enable: true,
                group: controller.listGroup.value[index],
              );
            }
          },
        ),
      ),
    );
  }
}

class GroupSettingsWidget extends StatelessWidget {
  const GroupSettingsWidget({
    Key? key,
    required this.group,
    required this.enable,
  }) : super(key: key);

  final GroupModel group;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
          leading: Badge(
            elevation: 0,
            badgeColor: Colors.green,
            badgeContent: Text(
              '${group.devices.length}',
              style: const TextStyle(color: Colors.white),
            ),
            child: const Icon(EvaIcons.gridOutline),
          ),
          title: Text(group.name.tr),
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => ListTile(
                title: Text(group.devices[index].friendlyName),
                subtitle: Text("#${group.devices[index].key}"),
              ),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: group.devices.length,
            ),
            if (enable)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///////// Add device
                  IconButton(
                    splashRadius: 24,
                    icon: const Icon(Icons.exposure, color: Colors.black54),
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        constraints: const BoxConstraints(maxWidth: 420),
                        builder: (context) {
                          return AddDeviceModal(group: group);
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    splashRadius: 24,
                    icon: const Icon(Icons.edit, color: Colors.black54),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        constraints: const BoxConstraints(maxWidth: 420),
                        builder: (context) {
                          return RenameModal(group: group);
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    splashRadius: 24,
                    icon: const Icon(Icons.delete, color: Colors.black54),
                    onPressed: () async {
                      final confirm = await confirmBottomModal(
                        context,
                        'deleteGroup'.tr,
                        'areUSure'.tr,
                      );
                      if (confirm) {
                        final c = Get.find<HomeController>();
                        c.deleteGroup(group.name);
                        Helper.showSuccess("done".tr);
                      }
                    },
                  ),
                  // const SizedBox(width: 10),
                  // IconButton(
                  //   splashRadius: 24,
                  //   onPressed: () async {
                  //     final confirm = await confirmBottomModal(
                  //         context,
                  //         "Ghim mặc định",
                  //         "Nhóm này sẽ hiển thị đầu tiên khi bạn vào ứng dụng");
                  //     if (confirm) {
                  //       // device.userConfig['groups'].remove(group.name);
                  //       // device.groups.removeWhere(
                  //       //     (element) => element.name == group.name);
                  //       // device.groupSelected = 0;
                  //       // device.updateGroupsToFirebase();
                  //     }
                  //   },
                  //   icon: const Icon(Icons.push_pin, color: Colors.green),
                  // )
                ],
              ),
          ],
        ),
      ],
    );
  }
}
