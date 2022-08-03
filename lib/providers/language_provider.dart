import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _appLocale = const Locale('vi', 'VN');

  Locale get appLocale {
    if (Hive.isBoxOpen('userConfig')) {
      final box = Hive.box('userConfig');
      final lang = box.get('language', defaultValue: 'vi');
      if (lang == 'vi') {
        _appLocale = Locale(lang, "VN");
      } else {
        _appLocale = Locale(lang, "US");
      }
    }

    return _appLocale;
  }

  void updateLanguage(String languageCode) async {
    final box = await Hive.openBox('userConfig');
    box.put('language', languageCode);

    if (languageCode == "vi") {
      _appLocale = const Locale("vi", "VN");
    } else {
      _appLocale = const Locale("en", "US");
    }

    /// Phat ra cho cac listeners
    notifyListeners();
  }
}
