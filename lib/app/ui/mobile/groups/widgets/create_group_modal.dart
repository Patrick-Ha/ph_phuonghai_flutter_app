import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

class CreateGroupModal extends StatefulWidget {
  const CreateGroupModal({Key? key}) : super(key: key);

  @override
  State<CreateGroupModal> createState() => _CreateGroupModalState();
}

class _CreateGroupModalState extends State<CreateGroupModal> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 400,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          children: [
            HeaderModal(title: "createGroup".tr),
            TextField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(
                labelText: "name".tr,
                helperText: 'hintCreateGroup'.tr,
                prefixIcon: const Icon(EvaIcons.gridOutline),
              ),
            ),
            const Spacer(),
            DefaultButton(
              text: 'confirm'.tr,
              press: () {
                final c = Get.find<HomeController>();
                if (_controller.text.isNotEmpty) {
                  final index = c.listGroup.value
                      .indexWhere((i) => i.name == _controller.text);
                  if (index == -1) {
                    c.createNewGroup(_controller.text);
                    Navigator.of(context).pop();
                    Helper.showSuccess("done".tr);
                  } else {
                    Helper.showError("errorGroup".tr);
                  }
                } else {
                  Helper.showError("errEmptyName".tr);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
