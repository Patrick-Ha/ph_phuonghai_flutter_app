import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/auth_controller.dart';
import 'package:phuonghai/app/Helper/helper.dart';
import 'package:phuonghai/app/ui/common/widgets/default_button.dart';
import 'package:phuonghai/app/ui/common/widgets/header_modal.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool hide = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
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
          HeaderModal(title: "signUp".tr),
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
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: hide,
            decoration: InputDecoration(
              labelText: "password".tr,
              filled: true,
              prefixIcon: const Icon(Icons.password),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _repeatPasswordController,
            obscureText: hide,
            decoration: InputDecoration(
              labelText: "repeatPassword".tr,
              filled: true,
              prefixIcon: const Icon(Icons.password),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
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
              ],
            ),
          ),
          const SizedBox(height: 20),
          DefaultButton(
            text: "signUp".tr,
            press: () {
              if (_passwordController.text != _repeatPasswordController.text) {
                Helper.showError("pwdIncorrect".tr);
              } else {
                final controller = Get.find<AuthController>();
                Helper.showLoading("signUp".tr);
                controller.signUp(
                  _emailController.text,
                  _passwordController.text,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
