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
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        children: [
          HeaderModal(title: "createGroup".tr),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    autofocus: true,
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "name".tr,
                      prefixIcon:
                          const Icon(Icons.dashboard_customize_outlined),
                    ),
                  ),
                  const Spacer(),
                  DefaultButton(
                    text: 'confirm'.tr,
                    press: () async {
                      if (_controller.text.isEmpty) {
                        Helper.showError('errEmptyName'.tr);
                      } else {
                        Helper.showLoading('loading'.tr);
                        final c = Get.find<HomeController>();

                        await c.createNewGroup(
                          _controller.text,
                          c.allGroups.last.oder + 1,
                          _controller.text,
                        );

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
    );
  }
}
