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
    _controller.text = widget.group.name.value;
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
        height: 300,
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            HeaderModal(title: "renameGroup".tr),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "name".tr,
                        prefixIcon: const Icon(Icons.widgets),
                      ),
                    ),
                    const Spacer(),
                    DefaultButton(
                      text: 'confirm'.tr,
                      press: () async {
                        if (_controller.text == widget.group.name.value) {
                          Navigator.of(context).pop();
                        } else {
                          Helper.showLoading('loading'.tr);
                          final c = Get.find<HomeController>();

                          await c.renameGroup(
                              widget.group.id, _controller.text);
                          widget.group.name.value = _controller.text;

                          Helper.dismiss();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
