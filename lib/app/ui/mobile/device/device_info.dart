import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/desktop/device_manage/device_manage_page.dart';

class DeviceInfo extends StatelessWidget {
  const DeviceInfo({Key? key, required this.model}) : super(key: key);
  final dynamic model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DividerWithText(text: "deviceInfo".tr),
        ListTile(
          title: Text(
            model.friendlyName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Dialog(
                    child: EditDeviceModal(
                      device: model,
                      admin: false,
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.edit),
            splashRadius: 18,
          ),
        ),
        const Divider(height: 6),
        ListTile(
          title: Text("model".tr),
          trailing: Text(
            model.model,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 6),
        ListTile(
          title: Text("serialNumber".tr),
          trailing: Text(
            model.key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 6),
        ListTile(
          title: Text("description".tr),
          subtitle: Text(model.description),
          isThreeLine: true,
        ),
        const Divider(height: 6),
      ],
    );
  }
}
