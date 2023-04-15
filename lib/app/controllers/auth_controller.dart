import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:phuonghai/app/Helper/helper.dart';
import 'package:phuonghai/app/data/models/user.dart';

const baseUrl = 'http://thegreenlab.xyz:3000/Users/Auth';

class AuthController extends GetxController {
  bool isLogged = false;
  final _dio = Dio();
  late final Box boxAuth;

  @override
  void onInit() async {
    super.onInit();
    boxAuth = await Hive.openBox("authentication");
    final log = boxAuth.get("isLogged");
    if (log == null) {
      isLogged = false;
    } else {
      isLogged = true;
    }
  }

  Future<int> login(String email, String pwd) async {
    int error = 0; // 0: not error, 1: no internet, 2: wrong pass, 3: ??
    try {
      final response = await _dio.post(
        baseUrl + '/Login',
        data: {'Email': email, 'Password': pwd},
      );

      print(response.data);

      if (response.data == "") {
        error = 2;
      } else {
        final token = base64.encode(utf8.encode("$email:$pwd"));
        final user = UserModel(
          id: response.data['Id'],
          email: response.data['Email'],
          token: "Basic $token",
        );
        await boxAuth.put("isLogged", user.toJson());
      }
    } on DioError catch (err) {
      debugPrint(err.toString());
      error = 1;
    } catch (e) {
      debugPrint(e.toString());
      error = 3;
    }
    return error;
  }

  void signUp(String email, String pwd) async {
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
    EasyLoading.dismiss();
  }

  void forgotPassword(String email) async {
    if (GetUtils.isEmail(email)) {
      try {
        final response = await _dio.post(
          baseUrl + '/ForgetPass',
          data: {'email': email},
        );
        if (response.statusCode == 400) {
          Helper.showError("accountNotFound".tr);
        } else {
          Helper.showSuccess("forgotPwdDone".tr);
        }
      } on DioError catch (e) {
        Helper.showError("noInternet".tr + " ${e.response!.statusCode}");
      } catch (e) {
        debugPrint(e.toString());
        Helper.showError("somethingWentWrong".tr);
      }
    } else {
      Helper.showError("isValidEmail".tr);
    }
    EasyLoading.dismiss();
  }

  // End
}
