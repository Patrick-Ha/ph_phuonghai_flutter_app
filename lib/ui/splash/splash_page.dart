import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phuonghai/constants/colors.dart';
import 'package:phuonghai/providers/auth_provider.dart';
import 'package:phuonghai/routes.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, navigate);
  }

  navigate() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.init();

    if (auth.status == AuthStatus.Authenticated) {
      if (kIsWeb || MediaQuery.of(context).size.width > 800) {
        Navigator.of(context).pushReplacementNamed(Routes.homeWeb);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.home);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.kGradient),
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
}
