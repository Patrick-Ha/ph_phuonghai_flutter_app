import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/ui/desktop/dashboard/widgets/group_web.dart';
import 'package:phuonghai/app/ui/mobile/dashboard/widgets/search_modal.dart';
import 'package:phuonghai/app/ui/mobile/groups/widgets/create_group_modal.dart';
import 'package:phuonghai/app/ui/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_device_web.dart';

class DashboardWeb extends GetWidget<HomeController> {
  const DashboardWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Material(
                color: Colors.green,
                child: Container(
                  height: 56,
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Image.asset('assets/images/avatar.png'),
                        ),
                        label: Obx(() => Text(controller.user.value.email)),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.dashboard_customize),
                        label: Text('createGroup'.tr),
                        onPressed: () async => await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const Dialog(child: CreateGroupModal());
                          },
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.search),
                        label: Text('search'.tr),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const Dialog(child: SearchModal());
                          },
                        ),
                      ),
                      const Spacer(),
                      Obx(
                        () => Visibility(
                          visible: !controller.visible.value,
                          child: InkWell(
                            onTap: () async {
                              await launchUrl(
                                  Uri.parse('https://smartph.online'));
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 28,
                                  child: Image.asset(
                                      "assets/images/logo-smartph.png"),
                                ),
                                const SizedBox(width: 5),
                                AnimatedTextKit(
                                  repeatForever: true,
                                  pause: const Duration(seconds: 30),
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      'Trạm quan trắc nước thải tự động - đáp ứng TT10/2021/BTNMT'
                                          .toUpperCase(),
                                      textStyle: const TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TypewriterAnimatedText(
                                      'Bấm để biết thêm thông tin'
                                          .toUpperCase(),
                                      textStyle: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                  onTap: () async {
                                    await launchUrl(
                                        Uri.parse('https://smartph.online'));
                                  },
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(gradient: kGradient),
                  child: SingleChildScrollView(
                    child: Obx(
                      () => Column(
                        children: List.generate(
                          controller.allGroups.length,
                          (index) => GroupWebT(
                            group: controller.allGroups[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // child: Obx(
                  //   () => ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: controller.allGroups.length,
                  //     itemBuilder: (c, i) =>
                  //         GroupWebT(group: controller.allGroups[i]),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.visible.value,
            child: const DetailDeviceWeb(),
          ),
        ),
      ],
    );
  }
}
