import 'package:academy_app/constants.dart';
import 'package:academy_app/providers/shared_pref_helper.dart';
import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = kDefaultLocale;
  bool _isRTL = true;

  Locale get locale => _locale;
  bool get isRTL => _isRTL;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await SharedPreferenceHelper().getLocale();
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
      _isRTL = kRTLLocales.contains(savedLocale);
      notifyListeners();
    }
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    _isRTL = kRTLLocales.contains(languageCode);
    await SharedPreferenceHelper().setLocale(languageCode);
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final newCode = _locale.languageCode == 'en' ? 'ar' : 'en';
    await setLocale(newCode);
  }
}
