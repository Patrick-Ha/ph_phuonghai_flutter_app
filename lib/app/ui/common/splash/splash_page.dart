import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phuonghai/app/controllers/auth_controller.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/ui/theme/app_colors.dart';
import 'package:version_check/version_check.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isNewVersion = false;

  @override
  void initState() {
    super.initState();
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      checkVersion();
    }
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        if (isNewVersion == false) {
          final c = Get.find<AuthController>();

          if (c.isLogged) {
            if (GetPlatform.isWeb || Get.width > 600) {
              Get.offNamed(Routes.WEB_HOME);
            } else {
              Get.offNamed(Routes.HOME);
            }
          } else {
            Get.offNamed(Routes.LOGIN);
          }
        }
      },
    );
  }

  Future checkVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final versionCheck = VersionCheck(
      packageName: "app.phuonghai",
      packageVersion: packageInfo.version,
      showUpdateDialog: customShowUpdateDialog,
      country: 'vn',
    );

    await versionCheck.checkVersion(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: const BoxDecoration(gradient: kGradient),
        child: const Center(
          child: Text(
            "Your Life\nIn\nYour Hand",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }

  void customShowUpdateDialog(BuildContext context, VersionCheck versionCheck) {
    isNewVersion = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('newUpdateAvailable'.tr),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('newVersion'.tr + ': ${versionCheck.storeVersion}'),
              Text(
                '(' + 'currentVersion'.tr + ': ${versionCheck.packageVersion})',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('update'.tr),
            onPressed: () async {
              await versionCheck.launchStore();
            },
          ),
        ],
      ),
    );
  }
}
