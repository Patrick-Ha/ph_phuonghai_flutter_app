import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';

import 'widgets/add_device_modal.dart';
import 'widgets/create_group_modal.dart';
import 'widgets/rename_modal.dart';

import 'package:badges/badges.dart' as badges;

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
          leading: badges.Badge(
            badgeContent: Text('3'),
            child: Icon(Icons.settings),
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
                // ...rest of the code
              ],
            ),
          ],
        ),
      ],
    );
  }
}
