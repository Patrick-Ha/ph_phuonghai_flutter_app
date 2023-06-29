import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:phuonghai/app/controllers/home_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/translations/app_translations.dart';
import 'package:phuonghai/app/ui/common/widgets/confirm_bottom_modal.dart';
import 'package:hive/hive.dart';
import 'package:phuonghai/app/ui/common/widgets/radio_dialog.dart';
import 'package:phuonghai/app/ui/common/widgets/textfield_dialog.dart';

class SettingsPage extends GetWidget<HomeController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            children: [
              Center(
                child: SizedBox(
                  height: 100,
                  child: Image.asset("assets/images/greenlab.png"),
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(controller.user.value.email),
                ),
              ),
              const Divider(),
              ListTile(
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  int index = 0;
                  if (Get.locale!.languageCode == 'vi') index = 1;
                  String code = await dialogWithRadio(context, index);
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
              Obx(
                () => ListTile(
                  leading: const Icon(Icons.smartphone_outlined),
                  title: Text("version".tr),
                  trailing: Text(controller.version.value),
                ),
              ),
              const Divider(),
              const ListTile(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  "logOut".tr,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  bool ret = false;
                  ret = await confirmBottomModal(
                    context,
                    'logOut'.tr,
                    'areUSure'.tr,
                  );

                  if (ret) {
                    final boxAuth = await Hive.openBox("authentication");
                    boxAuth.put("isLogged", null);
                    Get.offAndToNamed(Routes.LOGIN);
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.purple,
                ),
                title: Text(
                  "deleteAccount".tr,
                  style: const TextStyle(color: Colors.purple),
                ),
                onTap: () async {
                  final ret = await confirmBottomModal(
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
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
// class SettingsPage extends StatefulWidget {
//   const SettingsPage({Key? key}) : super(key: key);

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   String? email, version;
//   bool? developer;
//   int count = 0;

//   @override
//   initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       readSomeInfo();
//     });
//   }

//   readSomeInfo() async {
//     final boxAuth = await Hive.openBox("authentication");
//     final packageInfo = await PackageInfo.fromPlatform();

//     setState(() {
//       email = boxAuth.get("email");
//       developer = boxAuth.get("developer", defaultValue: false);
//       version = packageInfo.version;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(backgroundColor: Colors.white),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           constraints: const BoxConstraints(maxWidth: 420),
//           child: ListView(
//             children: [
//               Center(
//                 child: SizedBox(
//                   height: 100,
//                   child: Image.asset("assets/images/greenlab.png"),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ListTile(
//                 leading: const Icon(EvaIcons.personOutline),
//                 title: Text(email ?? ''),
//               ),
//               // const Divider(),
//               // ListTile(
//               //   leading: const Icon(EvaIcons.lockOutline),
//               //   title: Text("password".tr),
//               //   trailing: const Icon(EvaIcons.chevronRightOutline),
//               // ),
//               const Divider(),
//               ListTile(
//                 trailing: const Icon(EvaIcons.chevronRightOutline),
//                 onTap: () async {
//                   int _index = 0;
//                   if (Get.locale!.languageCode == 'vi') _index = 1;
//                   String code = await dialogWithRadio(context, _index);
//                   if (code != "NA") {
//                     Future.delayed(
//                       const Duration(milliseconds: 150),
//                       () => AppTranslations.changeLocale(code),
//                     );
//                   }
//                 },
//                 title: Text("language".tr),
//                 leading: CircleFlag(
//                   Get.locale!.countryCode!,
//                   size: 24,
//                 ),
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(EvaIcons.smartphoneOutline),
//                 title: Text("version".tr),
//                 trailing: Text(version ?? ''),
//               ),
//               const Divider(),
//               const ListTile(),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(EvaIcons.logOutOutline),
//                 title: Text(
//                   "logOut".tr,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//                 onTap: () async {
//                   bool ret = false;
//                   ret = await confirmBottomModal(
//                     context,
//                     'logOut'.tr,
//                     'areUSure'.tr,
//                   );

//                   if (ret) {
//                     final boxAuth = await Hive.openBox("authentication");
//                     boxAuth.put("isLogged", null);
//                     Get.offAndToNamed(Routes.LOGIN);
//                   }
//                 },
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(
//                   EvaIcons.trash2,
//                   color: Colors.purple,
//                 ),
//                 title: Text(
//                   "deleteAccount".tr,
//                   style: const TextStyle(color: Colors.purple),
//                 ),
//                 onTap: () async {
//                   final ret = await confirmBottomModal(
//                     context,
//                     'deleteAccount'.tr,
//                     'areUSure'.tr + "\n" + "hintDeleteAccount".tr,
//                   );

//                   if (ret) {
//                     final pwd = await textFieldDialog(
//                       context,
//                       "hintPassword".tr,
//                       false,
//                     );
//                     if (pwd.isNotEmpty) {
//                       final c = Get.find<HomeController>();
//                       final del = await c.apiClient.deleteAccount(pwd);
//                       if (del) {
//                         final boxAuth = await Hive.openBox("authentication");
//                         boxAuth.put("isLogged", null);
//                         Get.offAndToNamed(Routes.LOGIN);
//                       } else {
//                         Helper.showError("wrongPass".tr);
//                       }
//                     }
//                   }
//                 },
//               ),
//               const Divider(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
