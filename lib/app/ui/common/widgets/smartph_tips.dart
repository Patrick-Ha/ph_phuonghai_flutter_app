import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'header_modal.dart';

class SmartpHTips extends StatelessWidget {
  const SmartpHTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderModal(title: "status".tr),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.blueGrey,
                  ),
                  title: Text('normalTooltip'.tr),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text('goodTooltip'.tr),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.notifications_active,
                    color: Colors.red,
                  ),
                  title: Text('alarmTooltip'.tr),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.report,
                    color: Colors.amber,
                  ),
                  title: Text('errorTooltip'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
