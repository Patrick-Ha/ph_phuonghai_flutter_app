import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'en_us.dart';
import 'vi_vn.dart';

class AppTranslations extends Translations {
  static Future<Locale?> get locale async {
    return await _getLocaleFromLocal();
  }

  static const fallbackLocale = Locale('vi', 'VN');

  // các Locale được support
  static final locales = [
    const Locale('en', 'US'),
    const Locale('vi', 'VN'),
  ];

  static final langCodes = [
    'en',
    'vi',
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'vi_VN': vi_VN,
      };

  static void changeLocale(String langCode) async {
    final locale = _getLocaleFromLanguage(langCode);
    final boxAuth = await Hive.openBox("authentication");
    boxAuth.put("language", langCode);
    Get.updateLocale(locale);
  }

  static Locale _getLocaleFromLanguage(String? langCode) {
    for (int i = 0; i < langCodes.length; i++) {
      if (langCode == langCodes[i]) return locales[i];
    }
    return fallbackLocale;
  }

  static Future<Locale> _getLocaleFromLocal() async {
    final boxAuth = await Hive.openBox("authentication");
    final language = boxAuth.get("language", defaultValue: '');
    return _getLocaleFromLanguage(language);
  }
}
