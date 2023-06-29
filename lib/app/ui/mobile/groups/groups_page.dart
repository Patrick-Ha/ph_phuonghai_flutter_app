import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';

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
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 38),
          ),
          onPressed: () async => await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Dialog(child: CreateGroupModal());
            },
          ),
          icon: const Icon(
            Icons.dashboard_customize_outlined,
            color: Colors.yellowAccent,
          ),
          label: Text("createGroup".tr),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.allGroups.length,
          itemBuilder: (context, index) => GroupSettingsWidget(
            group: controller.allGroups[index],
          ),
        ),
      ),
    );
  }
}

class GroupSettingsWidget extends StatelessWidget {
  const GroupSettingsWidget({
    Key? key,
    required this.group,
  }) : super(key: key);

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
          leading: Badge(
            label: Text('${group.devices.length}'),
            backgroundColor: Colors.green,
            child: const Icon(Icons.grid_view),
          ),
          title: Text(group.name.value.tr),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///////// Add device
                IconButton(
                  splashRadius: 24,
                  icon: const Icon(Icons.exposure, color: Colors.black54),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(child: AddDeviceModal(group: group));
                      },
                    );
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  splashRadius: 24,
                  icon: const Icon(Icons.edit, color: Colors.black54),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(child: RenameModal(group: group));
                      },
                    );
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  splashRadius: 24,
                  icon: const Icon(Icons.delete, color: Colors.black54),
                  onPressed: () async {
                    final confirm = await confirmDialog(
                        context, 'deleteGroup'.tr, 'areUSure'.tr);
                    if (confirm) {
                      Helper.showLoading('loading'.tr);
                      final c = Get.find<HomeController>();
                      await c.deleteGroup(group.id);
                      Helper.dismiss();
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
