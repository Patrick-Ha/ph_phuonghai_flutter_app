import 'package:badges/badges.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/iaq_card.dart';
import 'package:phuonghai/app/ui/mobile/groups/widgets/add_device_modal.dart';
import 'package:phuonghai/app/ui/mobile/groups/widgets/rename_modal.dart';

class GroupWeb extends StatelessWidget {
  const GroupWeb({Key? key, required this.group}) : super(key: key);
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Badge(
                        elevation: 0,
                        badgeColor: Colors.green,
                        badgeContent: Text(
                          '${group.devices.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: const Icon(
                          EvaIcons.gridOutline,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        group.name.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (group.name != 'allDevices') ...[
                  IconButton(
                    splashRadius: 18,
                    iconSize: 20,
                    color: Colors.black54,
                    tooltip: 'addDevice'.tr,
                    icon: const Icon(Icons.exposure_outlined),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(child: AddDeviceModal(group: group));
                      },
                    ),
                  ),
                  IconButton(
                    splashRadius: 18,
                    iconSize: 22,
                    tooltip: 'renameGroup'.tr,
                    color: Colors.black54,
                    icon: const Icon(EvaIcons.editOutline),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(child: RenameModal(group: group));
                      },
                    ),
                  ),
                  IconButton(
                    splashRadius: 18,
                    iconSize: 22,
                    tooltip: 'deleteGroup'.tr,
                    color: Colors.black54,
                    icon: const Icon(EvaIcons.close),
                    onPressed: () async {
                      final ret = await confirmDialog(
                        context,
                        "deleteGroup".tr,
                        "areUSure".tr,
                      );
                      if (ret) {
                        final c = Get.find<HomeController>();
                        c.deleteGroup(group.name);
                        Helper.showSuccess("done".tr);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          Expanded(
              child: group.devices.isEmpty
                  ? Center(
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
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        if (group.devices[index].type == "Air Node") {
                          return IaqCard(model: group.devices[index]);
                        } else {
                          return DeviceCard(model: group.devices[index]);
                        }
                      },
                      itemCount: group.devices.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                    )),
        ],
      ),
    );
  }
}
