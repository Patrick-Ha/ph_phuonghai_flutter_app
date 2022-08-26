import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

class RenameModal extends StatefulWidget {
  const RenameModal({
    Key? key,
    required this.group,
  }) : super(key: key);

  final GroupModel group;

  @override
  State<RenameModal> createState() => _RenameModalState();
}

class _RenameModalState extends State<RenameModal> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.group.name;
    super.initState();
  }

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
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            HeaderModal(title: "renameGroup".tr),
            TextField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(
                labelText: "name".tr,
                helperText: 'hintCreateGroup'.tr,
              ),
            ),
            const Spacer(),
            DefaultButton(
              text: 'confirm'.tr,
              press: () {
                final c = Get.find<HomeController>();
                if (_controller.text == widget.group.name) {
                  Navigator.of(context).pop();
                  Helper.showSuccess("done".tr);
                } else {
                  final index = c.listGroup.value
                      .indexWhere((i) => i.name == _controller.text);
                  if (index == -1) {
                    c.renameGroup(widget.group.name, _controller.text);
                    widget.group.name = _controller.text;
                    Navigator.of(context).pop();
                    Helper.showSuccess("done".tr);
                  } else {
                    Helper.showError("errorGroup".tr);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
