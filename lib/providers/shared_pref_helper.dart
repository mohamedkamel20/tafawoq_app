// ignore_for_file: constant_identifier_names, camel_case_types
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<bool> setAuthToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userPref.AuthToken.toString(), token);
  }

  Future<String?> getAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userPref.AuthToken.toString());
  }

  // Future<bool> setUserData(String userData) async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.setString(userPref.UserData.toString(), userData);
  // }
  //
  // Future<String?> getUserData() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.getString(userPref.UserData.toString());
  // }

  Future<bool> setUserImage(String image) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userPref.Image.toString(), image);
  }

  Future<String?> getUserImage() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userPref.Image.toString());
  }

  Future<bool> setLocale(String locale) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userPref.Locale.toString(), locale);
  }

  Future<String?> getLocale() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userPref.Locale.toString());
  }

  Future<bool> clearAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove(userPref.AuthToken.toString());
  }
}

enum userPref {
  AuthToken,
  Image,
  Locale,
}
