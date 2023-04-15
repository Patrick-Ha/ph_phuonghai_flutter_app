import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

class GroupBottomModal extends StatelessWidget {
  GroupBottomModal({Key? key}) : super(key: key);
  final c = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            HeaderModal(title: "groupDisplay".tr),
            ListView.builder(
              shrinkWrap: true,
              itemCount: c.allGroups.length,
              itemBuilder: ((context, index) {
                if (index == c.selectedGroup.value) {
                  return GroupTitle(
                    text: c.allGroups[index].name.value,
                    select: true,
                    onTap: () => Navigator.of(context).pop(),
                  );
                } else {
                  return GroupTitle(
                    text: c.allGroups[index].name.value,
                    onTap: () {
                      c.selectedGroup.value = index;
                      Navigator.of(context).pop();
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupTitle extends StatelessWidget {
  const GroupTitle({
    Key? key,
    this.select = false,
    this.onTap,
    required this.text,
  }) : super(key: key);

  final bool select;
  final String text;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: select ? Colors.green[50] : null,
          border: Border(
            bottom:
                select ? BorderSide.none : BorderSide(color: Colors.grey[300]!),
            left: BorderSide(
              color: select ? Colors.green : Colors.transparent,
              width: 5,
            ),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
