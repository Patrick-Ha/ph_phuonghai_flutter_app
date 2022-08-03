import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phuonghai/constants/colors.dart';
import 'package:phuonghai/helper/keyboard.dart';
import 'package:phuonghai/providers/auth_provider.dart';
import 'package:phuonghai/routes.dart';
import 'package:phuonghai/ui/widgets/default_button.dart';
import 'package:phuonghai/utils/locale/app_localization.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();

  String _errorText = '';

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
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: const BoxDecoration(gradient: AppColors.kGradient),
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
                    // key: _formKey,
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
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    _errorText = "";
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email,
                                      color: Colors.white),
                                  labelText: locale.translate("loginTxtEmail"),
                                  hintText: locale.translate("hintEmail"),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                obscureText: true,
                                enableSuggestions: false,
                                controller: _passwordController,
                                onChanged: (value) {
                                  setState(() {
                                    _errorText = "";
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Colors.white),
                                  labelText:
                                      locale.translate("loginTxtPassword"),
                                  hintText: locale.translate("hintPassword"),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 20),
                              auth.status == AuthStatus.Authenticating
                                  ? Center(
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: LoadingAnimationWidget
                                            .prograssiveDots(
                                          color: Colors.yellow,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 30,
                                      child: Text(
                                        _errorText,
                                        style: const TextStyle(
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ),
                              DefaultButton(
                                text: locale.translate("loginBtnSignIn"),
                                press: () async {
                                  KeyboardUtil.hideKeyboard(context);
                                  if (_emailController.text.isEmpty |
                                      _passwordController.text.isEmpty) {
                                    setState(() {
                                      _errorText = 'error';
                                      locale.translate("loginTxtError");
                                    });
                                  } else {
                                    bool status = await auth.login(
                                        _emailController.text,
                                        _passwordController.text);
                                    if (status) {
                                      Future.delayed(Duration.zero, () {
                                        if (kIsWeb ||
                                            MediaQuery.of(context).size.width >
                                                800) {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  Routes.homeWeb);
                                        } else {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  Routes.home);
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        _errorText = locale
                                            .translate("loginTxtWrongPassword");
                                      });
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
                              locale.translate('txtNoAccount'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //const Spacer(),
                            TextButton(
                              onPressed: () {
                                _errorText = "";
                                KeyboardUtil.hideKeyboard(context);
                                Navigator.of(context).pushNamed(Routes.signUp);
                              },
                              child: Text(
                                locale.translate('txtSignUp'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
    });
  }
}







  // void inforAlert() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(AppLocalizations.of(context).translate('contactInfo')),
  //           content: SizedBox(
  //             width: MediaQuery.of(context).size.width,
  //             child: ListView(
  //               shrinkWrap: true,
  //               children: const [
  //                 ListTile(
  //                   leading: Icon(Icons.phone_outlined),
  //                   title: Text("(+84) 0917 647 887"),
  //                 ),
  //                 ListTile(
  //                   leading: Icon(Icons.email_outlined),
  //                   title: Text("info@phuonghai.com"),
  //                 ),
  //                 ListTile(
  //                   leading: Icon(Icons.language_outlined),
  //                   title: Text("www.phuonghai.com"),
  //                 ),
  //                 ListTile(
  //                   leading: Icon(Icons.location_on_outlined),
  //                   title: Text("103/23 Nguyễn Hữu Dật, Tân Phú, Việt Nam"),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }