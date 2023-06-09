import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/data/models/group.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/device_card.dart';
import 'package:phuonghai/app/ui/common/widgets/iaq_card.dart';
import 'package:phuonghai/app/ui/desktop/dashboard/widgets/environ_card_web.dart';
import 'package:phuonghai/app/ui/desktop/dashboard/widgets/refrigerator_card_web.dart';
import 'package:phuonghai/app/ui/common/widgets/templog_card.dart';
import 'package:phuonghai/app/ui/mobile/groups/widgets/add_device_modal.dart';
import 'package:phuonghai/app/ui/mobile/groups/widgets/rename_modal.dart';

class GroupWebT extends StatefulWidget {
  const GroupWebT({Key? key, required this.group}) : super(key: key);
  final GroupModel group;

  @override
  State<GroupWebT> createState() => _GroupWebTState();
}

class _GroupWebTState extends State<GroupWebT> {
  final _controller = ScrollController();
  final c = Get.find<HomeController>();
  final hover = false.obs;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 670),
      padding: const EdgeInsets.only(bottom: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.white54,
            child: Container(
              height: 45,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    splashRadius: 18,
                    icon: Obx(
                      () => widget.group.visible.value
                          ? Icon(
                              Icons.expand_less,
                              color: hover.value ? Colors.white : null,
                            )
                          : Icon(
                              Icons.expand_more,
                              color: hover.value ? Colors.white : null,
                            ),
                    ),
                    onPressed: () => widget.group.visible.toggle(),
                  ),
                  Expanded(
                    child: InkWell(
                      onHover: (value) => hover.value = value,
                      onTap: () => widget.group.visible.toggle(),
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Row(
                        children: [
                          Obx(
                            () => Text(
                              widget.group.name.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 26,
                            constraints: const BoxConstraints(minWidth: 28),
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Obx(
                              () => Text(
                                widget.group.devices.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    splashRadius: 18,
                    iconSize: 22,
                    tooltip: 'addDevice'.tr,
                    icon: const Icon(Icons.exposure_outlined),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                              child: AddDeviceModal(group: widget.group));
                        },
                      );
                    },
                  ),
                  IconButton(
                    splashRadius: 18,
                    iconSize: 22,
                    tooltip: 'renameGroup'.tr,
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: RenameModal(group: widget.group),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    splashRadius: 18,
                    iconSize: 22,
                    tooltip: 'deleteGroup'.tr,
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      final confirm = await confirmDialog(
                          context, 'deleteGroup'.tr, 'areUSure'.tr);
                      if (confirm) {
                        Helper.showLoading('loading'.tr);
                        final c = Get.find<HomeController>();
                        await c.deleteGroup(widget.group.id);
                        Helper.dismiss();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: widget.group.visible.value,
              maintainState: true,
              // child: Expanded(
              //   child: Scrollbar(
              //     thickness: 8,
              //     radius: const Radius.circular(22),
              //     trackVisibility: true,
              //     thumbVisibility: true,
              //     controller: _controller,
              //     child: ListView.builder(
              //       controller: _controller,
              //       shrinkWrap: true,
              //       scrollDirection: Axis.horizontal,
              //       padding: const EdgeInsets.only(
              //         left: 12,
              //         top: 10,
              //         bottom: 16,
              //       ),
              //       itemBuilder: (context, index) {
              //         if (widget.group.devices[index].type == 'Air Node') {
              //           return Container(
              //             constraints: const BoxConstraints(maxWidth: 360),
              //             margin: const EdgeInsets.only(right: 8),
              //             child: IaqCard(model: widget.group.devices[index]),
              //           );
              //         } else if (widget.group.devices[index].type ==
              //             'TempLog') {
              //           return Container(
              //             constraints: const BoxConstraints(maxWidth: 360),
              //             margin: const EdgeInsets.only(right: 8),
              //             child: TempLogCard(
              //               model: widget.group.devices[index],
              //             ),
              //           );
              //         } else if (widget.group.devices[index].type ==
              //             'Refrigerator') {
              //           return Container(
              //             constraints: const BoxConstraints(maxWidth: 420),
              //             margin: const EdgeInsets.only(right: 8),
              //             child: RefrigeratorCardWeb(
              //               model: widget.group.devices[index],
              //             ),
              //           );
              //         } else {
              //           return Container(
              //             constraints: const BoxConstraints(maxWidth: 360),
              //             margin: const EdgeInsets.only(right: 8),
              //             child: DeviceCard(model: widget.group.devices[index]),
              //           );
              //         }
              //       },
              //       itemCount: widget.group.devices.length,
              //     ),
              //   ),
              // ),
              child: Scrollbar(
                thickness: 8,
                radius: const Radius.circular(22),
                controller: _controller,
                trackVisibility: true,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 12,
                    top: 12,
                    bottom: 22,
                  ),
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.group.devices.length,
                      (index) {
                        if (widget.group.devices[index].type == 'Air Node') {
                          return Container(
                            constraints: const BoxConstraints(maxWidth: 360),
                            margin: const EdgeInsets.only(right: 8),
                            child: IaqCard(model: widget.group.devices[index]),
                          );
                        } else if (widget.group.devices[index].type ==
                            'TempLog') {
                          return Container(
                            constraints: const BoxConstraints(maxWidth: 360),
                            margin: const EdgeInsets.only(right: 8),
                            child: TempLogCard(
                              model: widget.group.devices[index],
                            ),
                          );
                        } else if (widget.group.devices[index].type ==
                            'Refrigerator') {
                          return Container(
                            constraints: const BoxConstraints(maxWidth: 440),
                            margin: const EdgeInsets.only(right: 8),
                            child: RefrigeratorCardWeb(
                              model: widget.group.devices[index],
                            ),
                          );
                        } else if (widget.group.devices[index].type ==
                            'Environmental Chamber') {
                          return Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            margin: const EdgeInsets.only(right: 8),
                            child: EnvironCardWeb(
                              model: widget.group.devices[index],
                            ),
                          );
                        } else {
                          return Container(
                            constraints: const BoxConstraints(maxWidth: 360),
                            margin: const EdgeInsets.only(right: 8),
                            child:
                                DeviceCard(model: widget.group.devices[index]),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
