import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Helper {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void showError(String status) {
    EasyLoading.instance
      ..indicatorColor = Colors.red
      ..loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.showError(
      status,
      maskType: EasyLoadingMaskType.custom,
    );
  }

  static void showLoading(String status) {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
    EasyLoading.show(
      status: status,
      maskType: EasyLoadingMaskType.black,
    );
  }

  static void showSuccess(String status) {
    EasyLoading.instance
      ..indicatorColor = Colors.green
      ..loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.showSuccess(
      status,
      maskType: EasyLoadingMaskType.custom,
    );
  }

  static void dismissLoad() {
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }
}
