import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/auth_controller.dart';
import 'package:phuonghai/app/helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("signUp".tr)),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              TextField(
                controller: emailController,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "email".tr,
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password".tr,
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 50),
              DefaultButton(
                text: "signUp".tr,
                press: () {
                  final controller = Get.find<AuthController>();
                  Helper.showLoading("signUp".tr);
                  controller.signUp(
                    emailController.text,
                    passwordController.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
