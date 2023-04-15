import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:phuonghai/app/controllers/auth_controller.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/ui/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 1000),
      () async {
        final c = Get.find<AuthController>();
        bool update = false;
        if (GetPlatform.isAndroid || GetPlatform.isIOS) {
          update = await checkNewVersion();
        }
        if (!update) {
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

  Future<bool> checkNewVersion() async {
    final version = await AppVersionUpdate.checkForUpdates(
      appleId: '1634339111',
      playStoreId: 'app.phuonghai',
      country: 'vn',
    );

    if (version.canUpdate == true) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "newUpdateAvailable".tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "${"newVersion".tr}: "),
                  TextSpan(
                    text: version.storeVersion,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("update".tr.toUpperCase()),
                onPressed: () {
                  LaunchReview.launch(
                    writeReview: false,
                    androidAppId: "app.phuonghai",
                    iOSAppId: "1634339111",
                  );
                },
              ),
            ],
          );
        },
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: kGradient),
        child: const Center(
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Agne',
              color: Colors.white,
            ),
            child: Text(
              'Your Life\nIn\nYour Hand',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
