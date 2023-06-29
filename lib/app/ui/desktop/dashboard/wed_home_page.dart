import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/translations/app_translations.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/divider_with_text.dart';
import 'package:phuonghai/app/ui/common/widgets/radio_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/textfield_dialog.dart';
import 'package:phuonghai/app/ui/desktop/device_manage/device_manage_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/dashboard_web.dart';
import 'widgets/item_drawer.dart';
import 'widgets/user_manage_page.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({Key? key}) : super(key: key);

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  final controller = Get.find<HomeController>();
  int _index = 0;

  Widget _getPage(int index) {
    if (index == 0) {
      return const DashboardWeb();
    } else if (index == 1) {
      return const DeviceManagePage();
    } else {
      return const UserManagePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: Image.asset('assets/images/avatar.png'),
                accountName: InkWell(
                  onTap: () async {
                    await launchUrl(Uri.parse('https://smartph.online'));
                  },
                  child: const Text(
                    'https://smartph-online.com',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                accountEmail: Obx(() => Text(controller.user.value.email)),
              ),
              ItemDrawer(
                isSelected: _index == 0,
                icon: const Icon(Icons.home),
                text: 'dashboard'.tr,
                press: () {
                  if (_index != 0) {
                    setState(() {
                      _index = 0;
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ItemDrawer(
                        display: controller.admin.value,
                        isSelected: _index == 1,
                        icon: const Icon(Icons.workspaces_filled),
                        text: 'manageDevice'.tr,
                        press: () async {
                          Navigator.of(context).pop();
                          controller.apiClient.devicesDisplay.clear();
                          controller.apiClient.devicesDisplay
                              .assignAll(controller.apiClient.devices);
                          if (_index != 1) {
                            setState(() {
                              _index = 1;
                            });
                          }
                        },
                      ),
                      ItemDrawer(
                        display: controller.admin.value,
                        isSelected: _index == 2,
                        icon: const Icon(Icons.group),
                        text: 'manageUser'.tr,
                        press: () {
                          if (_index != 2) {
                            setState(() {
                              _index = 2;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )),
              const Spacer(),
              DividerWithText(text: 'settings'.tr),
              Obx(
                () => ItemDrawer(
                  icon: const Icon(Icons.smartphone_outlined),
                  text: "${"version".tr}: ${controller.version.value}",
                ),
              ),
              ItemDrawer(
                icon: CircleFlag(
                  Get.locale!.countryCode!,
                  size: 22,
                ),
                text: "language".tr,
                press: () async {
                  int index = 0;
                  if (Get.locale!.languageCode == 'vi') index = 1;
                  String code = await dialogWithRadio(context, index);
                  if (code != "NA") {
                    AppTranslations.changeLocale(code);
                  }
                },
              ),
              ItemDrawer(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                text: "logOut".tr,
                press: () async {
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
              ItemDrawer(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.purple,
                ),
                text: "deleteAccount".tr,
                press: () async {
                  final ret = await confirmDialog(
                    context,
                    'deleteAccount'.tr,
                    "${'areUSure'.tr}\n${"hintDeleteAccount".tr}",
                  );
                  if (ret && context.mounted) {
                    final pwd = await textFieldDialog(
                      context,
                      "hintPassword".tr,
                      false,
                    );
                    if (pwd.isNotEmpty) {
                      final c = Get.find<HomeController>();
                      final del = await c.apiClient.deleteAccountByUser(pwd);
                      if (del) {
                        final boxAuth = await Hive.openBox("authentication");
                        boxAuth.put("isLogged", null);
                        Get.offAndToNamed(Routes.LOGIN);
                      } else {
                        Helper.showError("wrongPass".tr);
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        body: _getPage(_index),
      ),
    );
  }
}
