// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phuonghai/models/user_model.dart';

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  RegisterError,
  RegisterDone,
  Registering
}
/*
The UI will depends on the AuthStatus to decide which screen/action to be done.

- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown

Take note, this is just an idea. You can remove or further add more different
status for your UI or widgets to listen.
 */

class AuthProvider extends ChangeNotifier {
  // Default status
  AuthStatus _status = AuthStatus.Uninitialized;
  AuthStatus get status => _status;

  final UserModel _user = UserModel(uid: 'null', token: 'null');
  UserModel get user => _user;

  Future<void> init() async {
    final boxAuth = await Hive.openBox("authentication");
    final isLogged = boxAuth.get("isLoggedIn", defaultValue: false);
    if (isLogged) {
      _status = AuthStatus.Authenticated;
      _user.email = boxAuth.get("email");
      _user.pwd = boxAuth.get("pwd");
    } else {
      _status = AuthStatus.Uninitialized;
    }
  }

  Future<bool> login(String email, String pwd) async {
    _status = AuthStatus.Authenticating;
    notifyListeners();

    final Dio _dio = Dio();
    try {
      final response = await _dio.post(
        'https://thegreenlab.xyz/Users/Auth/Login',
        data: {'Email': email, 'Password': pwd},
      );

      if (response.data == "") {
        _status = AuthStatus.Unauthenticated;
        return false;
      } else {
        _status = AuthStatus.Authenticated;
        _user.email = _user.email = email;
        _user.pwd = pwd;
        _user.token = base64.encode(utf8.encode("$email:$pwd"));

        final boxAuth = await Hive.openBox("authentication");
        boxAuth.put("isLoggedIn", true);
        boxAuth.put("email", email);
        boxAuth.put("pwd", pwd);

        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      _status = AuthStatus.Unauthenticated;
      return false;
    }
  }

  Future<void> signOut() async {
    final boxAuth = await Hive.openBox("authentication");
    boxAuth.put("isLoggedIn", false);
  }

  Future<int> signUp(String email, String pwd) async {
    int _code = 2;

    _status = AuthStatus.Registering;
    notifyListeners();

    final Dio _dio = Dio();
    try {
      final response = await _dio.post(
        'https://thegreenlab.xyz/Users/Auth/Register',
        data: {'Email': email, 'Password': pwd},
      );

      if (response.statusCode == 201) {
        if (response.data.containsKey('message')) {
          // Tai khoan da co
          _code = 1;
        } else {
          // Dang ky thanh cong
          _code = 0;
        }
      }
    } catch (e) {
      _code = 2; // Loi
    }
    _status = AuthStatus.Unauthenticated;
    return _code;
  }
}
