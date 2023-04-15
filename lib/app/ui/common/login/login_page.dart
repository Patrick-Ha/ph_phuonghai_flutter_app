import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/auth_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/routes/app_pages.dart';
import 'package:phuonghai/app/ui/common/sign_up/sign_up_page.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';
import 'package:phuonghai/app/ui/theme/app_colors.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool hide = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  loginFunction() async {
    if (emailController.text == 'admin' ||
        (GetUtils.isEmail(emailController.text) &&
            passwordController.text.length >= 6)) {
      Helper.showLoading("logIn".tr);
      final controller = Get.find<AuthController>();
      final logged = await controller.login(
        emailController.text,
        passwordController.text,
      );
      EasyLoading.dismiss();
      if (logged == 0) {
        if (GetPlatform.isWeb || Get.width > 600) {
          Get.offNamed(Routes.WEB_HOME);
        } else {
          Get.offNamed(Routes.HOME);
        }
      } else if (logged == 1) {
        Helper.showError("noInternet".tr);
      } else if (logged == 2) {
        Helper.showError("wrongIdOrPass".tr);
      } else if (logged == 3) {
        Helper.showError("somethingWentWrong".tr);
      }
    } else {
      Helper.showError("wrongIdOrPass".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(gradient: kGradient),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Phuong Hai Scientific",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            const Text(
              "www.phuonghai.com",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 90,
                    child: Image.asset(
                      "assets/images/greenlab.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: Image.asset("assets/images/logo-smartph.png"),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: "email".tr,
                            hintText: "hintEmail".tr,
                            filled: true,
                            fillColor: Colors.white30,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: const Icon(Icons.email),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: hide,
                          decoration: InputDecoration(
                            labelText: "password".tr,
                            hintText: "hintPassword".tr,
                            filled: true,
                            fillColor: Colors.white30,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: const Icon(Icons.password),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) async {
                            await loginFunction();
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          child: Row(
                            children: [
                              Checkbox(
                                value: !hide,
                                onChanged: (value) {
                                  setState(() {
                                    hide = !value!;
                                  });
                                },
                              ),
                              Text("showPass".tr),
                              const Spacer(),
                              InkWell(
                                child: Text(
                                  "forgotPassword".tr,
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Dialog(
                                          child: ForgotPasswordPage());
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: DefaultButton(
                                text: "signUp".tr,
                                bgColor: Colors.blueGrey,
                                press: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Dialog(child: SignUpPage());
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: DefaultButton(
                                text: "logIn".tr,
                                press: () async => loginFunction(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderModal(title: "forgotPassword".tr),
          TextField(
            controller: _emailController,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "email".tr,
              filled: true,
              prefixIcon: const Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 50),
          DefaultButton(
            text: "confirm".tr,
            press: () {
              final c = Get.find<AuthController>();
              Helper.showLoading("loading".tr);
              c.forgotPassword(_emailController.text);
            },
          ),
        ],
      ),
    );
  }
}
