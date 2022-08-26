import 'package:circle_flags/circle_flags.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/translations/app_translations.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/dialog_radio.dart';
import 'package:phuonghai/app/ui/desktop/dashboard/widgets/group_web.dart';
import 'package:phuonghai/app/ui/mobile/dashboard/widgets/search_modal.dart';
import 'package:phuonghai/app/ui/mobile/groups/widgets/create_group_modal.dart';

class WebHomePage extends GetWidget<HomeController> {
  WebHomePage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.green,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[100],
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.asset("assets/images/greenlab_512x512.png"),
              ),
            ),
            ListTile(
              leading: const Icon(EvaIcons.personOutline),
              title: Obx(() => Text(controller.email.value)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(EvaIcons.lockOutline),
              title: Text("password".tr),
              trailing: const Icon(EvaIcons.chevronRightOutline),
            ),
            const Divider(),
            ListTile(
              trailing: const Icon(EvaIcons.chevronRightOutline),
              onTap: () async {
                int _index = 0;
                if (Get.locale!.languageCode == 'vi') _index = 1;
                String code = await dialogWithRadio(context, _index);
                if (code != "NA") {
                  Future.delayed(
                    const Duration(milliseconds: 150),
                    () => AppTranslations.changeLocale(code),
                  );
                }
              },
              title: Text("language".tr),
              leading: CircleFlag(
                Get.locale!.countryCode!,
                size: 24,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(EvaIcons.smartphoneOutline),
              title: Text("version".tr),
              trailing: Obx(() => Text(controller.version.value)),
            ),
            const Divider(),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(EvaIcons.logOutOutline),
              title: Text(
                "logOut".tr,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () async {
                bool ret = false;

                ret = await confirmDialog(
                  context,
                  'logOut'.tr,
                  'areUSure'.tr,
                );

                if (ret) {
                  final boxAuth = await Hive.openBox("authentication");
                  boxAuth.put("isLoggedIn", false);
                  Get.offAndToNamed(Routes.LOGIN);
                  Get.delete<HomeController>();
                }
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xff087f23)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  //const EmailWidget(),
                  TextButton.icon(
                    style: TextButton.styleFrom(primary: Colors.white),
                    icon: const Icon(EvaIcons.settings),
                    label: Obx(() => Text(controller.email.value)),
                    onPressed: () => _key.currentState!.openDrawer(),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(primary: Colors.white),
                    icon: const Icon(EvaIcons.eye),
                    label: Text("hideAllDevices".tr),
                    onPressed: () {},
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(primary: Colors.white),
                    icon: const Icon(Icons.dashboard_customize),
                    label: Text('createGroup'.tr),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dialog(child: CreateGroupModal());
                      },
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(primary: Colors.white),
                    icon: const Icon(EvaIcons.search),
                    label: Text('search'.tr),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dialog(child: SearchModal());
                      },
                    ),
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 5),
                              LoadingAnimationWidget.discreteCircle(
                                color: Colors.white,
                                size: 15,
                                secondRingColor: Colors.purple,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'refresh'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemBuilder: (_, index) =>
                      GroupWeb(group: controller.listGroup.value[index]),
                  itemCount: controller.listGroup.value.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailWidget extends StatefulWidget {
  const EmailWidget({Key? key}) : super(key: key);

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  String email = 'N/A';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      readSomeInfo();
    });
  }

  readSomeInfo() async {
    final boxAuth = await Hive.openBox("authentication");
    setState(() {
      email = boxAuth.get("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(primary: Colors.white),
      icon: const Icon(EvaIcons.settingsOutline),
      label: Text(email),
      onPressed: () => Get.toNamed(Routes.SETTINGS),
    );
  }
}
