import 'package:flutter/material.dart';
import 'package:phuonghai/helper/keyboard.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  String errorText = '';

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(locale.translate('forgetPassword'))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text(
                locale.translate('resetPassword'),
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              Text(locale.translate('hintResetPwd')),
              const SizedBox(height: 100),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    errorText = "";
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: locale.translate("loginTxtEmail"),
                  hintText: locale.translate("hintEmail"),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                errorText,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                text: locale.translate('ok'),
                press: () async {
                  if (emailController.text.length > 6 &&
                      KeyboardUtil.checkIsEmail(emailController.text)) {
                    KeyboardUtil.hideKeyboard(context);
                    // final authProvider =
                    //     Provider.of<AuthProvider>(context, listen: false);
                    // bool isOk = await authProvider
                    //     .sendPasswordResetEmail(emailController.text);
                    // if (isOk) {
                    //   await confirmResetPwd(
                    //       context,
                    //       locale.translate('resetPassword'),
                    //       locale.translate('doneResetPwd'));
                    //   Navigator.of(context).pop(context);
                    // } else {
                    //   setState(() {
                    //     errorText = "Error";
                    //   });
                    // }
                  } else {
                    setState(() {
                      errorText = locale.translate('hintEmail');
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> confirmResetPwd(
    BuildContext context, String title, String content) async {
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context).translate('ok')),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      });
}
