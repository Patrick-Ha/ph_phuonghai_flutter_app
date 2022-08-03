import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/helper/keyboard.dart';
import 'package:phuonghai/providers/auth_provider.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/ui/widgets/status_widget.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorText = '';
  bool _error = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Consumer<AuthProvider>(builder: (_, auth, __) {
      return Scaffold(
        appBar: AppBar(title: Text(locale.translate('txtSignUp'))),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: locale.translate('loginTxtEmail'),
                      hintText: locale.translate('hintEmail'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: locale.translate('hintPassword'),
                      hintText: locale.translate('txtRequiredPass'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: auth.status == AuthStatus.Registering
                          ? LoadingAnimationWidget.prograssiveDots(
                              color: Colors.green,
                              size: 30,
                            )
                          : StatusWidget(
                              error: _error,
                              text: _errorText,
                            ),
                    ),
                  ),
                  DefaultButton(
                    text: locale.translate('txtSignUp'),
                    press: () async {
                      KeyboardUtil.hideKeyboard(context);
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(_emailController.text);
                      if (emailValid) {
                        if (_passwordController.text.length < 6) {
                          _error = true;
                          _errorText = "Mật khẩu tối thiểu 6 ký tự";
                        } else {
                          final state = await auth.signUp(
                              _emailController.text, _passwordController.text);
                          if (state == 0) {
                            _error = false;
                            _errorText = "Đăng ký tài khoản thành công";
                          } else if (state == 1) {
                            _error = true;
                            _errorText = "Tài khoản đã đăng ký";
                          } else {
                            _error = true;
                            _errorText = "Lỗi không xác định. Hãy thử lại.";
                          }
                        }
                      } else {
                        _error = true;
                        _errorText = "Nhập sai định dạng email";
                      }
                      setState(() {});
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        )),
      );
    });
  }
}
