import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/translations/app_translations.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_bottom_modal.dart';
import 'package:hive/hive.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/dialog_radio.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? email, version;
  bool? developer;
  int count = 0;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      readSomeInfo();
    });
  }

  readSomeInfo() async {
    final boxAuth = await Hive.openBox("authentication");
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      email = boxAuth.get("email");
      developer = boxAuth.get("developer", defaultValue: false);
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            children: [
              Center(
                child: SizedBox(
                  height: 120,
                  child: Image.asset("assets/images/greenlab.png"),
                ),
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(EvaIcons.personOutline),
                title: Text(email ?? ''),
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
                trailing: Text(version ?? ''),
                onTap: () async {
                  if (GetPlatform.isAndroid || GetPlatform.isIOS) {
                    if (developer == true) {
                      Get.toNamed(Routes.BLUETOOTH);
                    } else {
                      count++;
                      if (count == 10) {
                        final boxAuth = await Hive.openBox("authentication");
                        developer = true;
                        boxAuth.put("developer", true);
                      }
                    }
                  }
                },
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(EvaIcons.logOutOutline),
                title: Text(
                  "logOut".tr,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  bool ret = false;
                  if (GetPlatform.isWeb) {
                    ret = await confirmDialog(
                      context,
                      'logOut'.tr,
                      'areUSure'.tr,
                    );
                  } else {
                    ret = await confirmBottomModal(
                      context,
                      'logOut'.tr,
                      'areUSure'.tr,
                    );
                  }

                  if (ret) {
                    final boxAuth = await Hive.openBox("authentication");
                    boxAuth.put("isLoggedIn", false);
                    Get.offAndToNamed(Routes.LOGIN);
                    Get.delete<HomeController>();
                  }
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
