import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

class AddDeviceModal extends StatefulWidget {
  const AddDeviceModal({Key? key, required this.group}) : super(key: key);
  final GroupModel group;

  @override
  State<AddDeviceModal> createState() => _AddDeviceModalState();
}

class _AddDeviceModalState extends State<AddDeviceModal> {
  final c = Get.find<HomeController>();
  late List<dynamic> listDisplay;

  @override
  void initState() {
    super.initState();
    listDisplay = List.from(c.listGroup.value[0].devices);
  }

  bool checkDeviceInGroup(dynamic obj) {
    final isExist = widget.group.devices.indexWhere(
      (e) => e.key == obj.key,
    );

    if (isExist == -1) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          HeaderModal(title: "addDevice".tr),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              prefixIcon: const Icon(EvaIcons.search),
              helperText: "searchHint".tr,
            ),
            onChanged: (value) {
              listDisplay.clear();
              setState(() {
                for (var element in c.listGroup.value[0].devices) {
                  if (element.friendlyName
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                      element.key.toLowerCase().contains(value.toLowerCase())) {
                    listDisplay.add(element);
                  }
                }
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) => CheckboxListTile(
                secondary: SizedBox(
                  height: double.infinity,
                  child: Icon(
                    Icons.blur_circular_outlined,
                    color: listDisplay[index].type == 'Air Node'
                        ? Colors.green
                        : Colors.blue,
                  ),
                ),
                value: checkDeviceInGroup(listDisplay[index]),
                onChanged: (value) {
                  if (value == true) {
                    // Add thiet bi
                    final i = c.listGroup.value[0].devices.indexWhere(
                      (e) => e.key == listDisplay[index].key,
                    );
                    setState(() {
                      widget.group.devices.add(c.listGroup.value[0].devices[i]);
                      c.addDeviceToGroup(
                        widget.group.name,
                        listDisplay[index].key,
                      );
                    });
                    Get.snackbar(
                      "add".tr,
                      "done".tr,
                      backgroundColor: Colors.white60,
                      maxWidth: 420,
                      margin: const EdgeInsets.all(10),
                      icon: const Icon(EvaIcons.checkmark, color: Colors.green),
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 1),
                    );
                  } else {
                    // Go thi bi
                    setState(() {
                      widget.group.devices.removeWhere(
                        (e) => e.key == listDisplay[index].key,
                      );
                      c.removeDeviceFromGroup(
                        widget.group.name,
                        listDisplay[index].key,
                      );
                    });
                    Get.snackbar(
                      "remove".tr,
                      "done".tr,
                      backgroundColor: Colors.white60,
                      maxWidth: 420,
                      margin: const EdgeInsets.all(10),
                      icon: const Icon(EvaIcons.checkmark, color: Colors.green),
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 1),
                    );
                  }
                },
                title: Text(listDisplay[index].friendlyName),
                subtitle: Text("#${listDisplay[index].key}"),
              ),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: listDisplay.length,
            ),
          )
        ],
      ),
    );
  }
}
