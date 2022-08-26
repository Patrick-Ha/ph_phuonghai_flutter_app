import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/auth_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/theme/app_colors.dart';

class LogInPage extends StatelessWidget {
  LogInPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(gradient: kGradient),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Phuong Hai Scientific",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            const Text(
              "www.phuonghai.com",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 120,
                          child: Image.asset("assets/images/greenlab.png"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "email".tr,
                                prefixIcon: const Icon(Icons.email),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "password".tr,
                                prefixIcon: const Icon(Icons.password),
                              ),
                            ),
                            const SizedBox(height: 40),
                            DefaultButton(
                              text: "logIn".tr,
                              press: () async {
                                Helper.showLoading("logIn".tr);
                                final controller = Get.find<AuthController>();
                                final logged = await controller.login(
                                  emailController.text,
                                  passwordController.text,
                                );
                                if (!logged) {
                                  if (GetPlatform.isWeb || Get.width > 600) {
                                    Get.offNamed(Routes.WEB_HOME);
                                  } else {
                                    Get.offNamed(Routes.HOME);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "noAccount".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.SIGNUP);
                            },
                            child: Text(
                              "signUp".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
