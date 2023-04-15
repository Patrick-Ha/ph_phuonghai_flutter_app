import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/helper/helper.dart';
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
    listDisplay = List.from(c.allDevicesOfUser);
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
          Text(
            "[${widget.group.name}]",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              helperText: "searchHint".tr,
            ),
            onChanged: (value) {
              listDisplay.clear();
              setState(() {
                for (var element in c.allDevicesOfUser) {
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
                onChanged: (value) async {
                  if (value == true) {
                    // Add thiet bi
                    Helper.showLoading('loading'.tr);
                    await c.addDeviceToGroup(
                      widget.group.id,
                      listDisplay[index].id,
                    );
                    setState(() {
                      widget.group.devices.add(listDisplay[index]);
                    });
                    Helper.dismiss();
                  } else {
                    // Go thi bi
                    Helper.showLoading('loading'.tr);
                    await c.removeDeviceFromGroup(listDisplay[index].idInGroup);
                    setState(() {
                      widget.group.devices.removeWhere(
                        (e) => e.key == listDisplay[index].key,
                      );
                    });
                    Helper.dismiss();
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
