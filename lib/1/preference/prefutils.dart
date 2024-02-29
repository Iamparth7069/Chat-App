import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static late SharedPreferences _instance;

  static String isIntroFinished = 'intro';
  static String isLogin = 'isLogin';

  static Future<SharedPreferences> init() async {
    _instance = await SharedPreferences.getInstance();
    return _instance;
  }

  static Future<bool> updateOnBoardingStatus(bool status) async {
    return await _instance.setBool(isIntroFinished, status);
  }

  static bool getOnBoardingStatus() {
    return _instance.getBool(isIntroFinished) ?? false;
  }

  static Future<bool> updateLoginStatus(bool status) async {
    return await _instance.setBool(isLogin, status);
  }

  static bool getLoginStatus() {
    return _instance.getBool(isLogin) ?? false;
  }

  static Future<bool> logout() async {
    // _instance.clear();
    return await _instance.remove(isLogin);
  }
}
