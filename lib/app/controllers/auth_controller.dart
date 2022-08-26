import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:phuonghai/app/helper/helper.dart';

const baseUrl = 'https://thegreenlab.xyz/Users/Auth';

class AuthController extends GetxController {
  bool isLogged = false;

  @override
  void onInit() async {
    super.onInit();
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.light
      ..userInteractions = false
      ..progressColor = Colors.amber
      ..backgroundColor = Colors.white
      ..indicatorColor = Colors.red
      ..textColor = Colors.black
      ..maskColor = Colors.black26;
    final boxAuth = await Hive.openBox("authentication");
    isLogged = boxAuth.get("isLoggedIn", defaultValue: false);
  }

  Future<bool> login(String email, String pwd) async {
    bool error = true;
    final _dio = Dio();

    if (email.length <= 6 || pwd.length < 6) {
      Helper.showError("emailTooShort".tr);
    } else {
      try {
        final response = await _dio.post(
          baseUrl + '/Login',
          data: {'Email': email, 'Password': pwd},
        );

        if (response.data == "") {
          Helper.showError("wrongIdOrPass".tr);
        } else {
          error = false;
        }
      } on DioError {
        Helper.showError("noInternet".tr);
      } catch (e) {
        Helper.showError("somethingWentWrong".tr);
      }
    }

    if (!error) {
      final boxAuth = await Hive.openBox("authentication");
      boxAuth.put("isLoggedIn", true);
      boxAuth.put("email", email);
      boxAuth.put("pwd", pwd);
    }

    return error;
  }

  void signUp(String email, String pwd) async {
    final _dio = Dio();

    if (GetUtils.isEmail(email)) {
      if (pwd.length < 6) {
        Helper.showError("pwdTooShort".tr);
      } else {
        try {
          final response = await _dio.post(
            baseUrl + '/Register',
            data: {'Email': email, 'Password': pwd},
          );

          if (response.data.containsKey('message')) {
            Helper.showError("signUpError".tr);
          } else {
            // Dang ky thanh cong
            Helper.showSuccess("signUpDone".tr);
          }
        } on DioError {
          Helper.showError("noInternet".tr);
        } catch (e) {
          debugPrint(e.toString());
          Helper.showError("somethingWentWrong".tr);
        }
      }
    } else {
      Helper.showError("isValidEmail".tr);
    }
  }

  void logOut() async {
    final boxAuth = await Hive.openBox("authentication");
    boxAuth.put("isLoggedIn", false);
  }

  // End
}
