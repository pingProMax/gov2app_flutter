
// api------
import 'package:shared_preferences/shared_preferences.dart';

String ApiUrl = "https://www.52bd.top";

class Global {

  String AppName = "GoV2App"; //app名字

  String Vv = "v 1.0"; //版本号

  String RegisterUrl = "https://www.52bd.top/register"; //注册地址


  String PlanUrl = "https://www.52bd.top/user/plan"; //购买套餐地址



  String loginApi = ApiUrl + "/login";              // 登录api
  String getUserInfoApi =  ApiUrl + "/user";        // 用户信息api
  String subApi = ApiUrl + "/api/subscribe"; // 订阅api
  String appBulApi = ApiUrl + "/user/app_bulletin"; // 公告api
}

Global global = Global();

class PrefUtil {
  static late final SharedPreferences preferences;
  static bool _init = false;
  static Future init() async {
    if (_init) return;
    preferences = await SharedPreferences.getInstance();
    _init = true;
    return preferences;
  }

  static setValue(String key, Object value) {
    switch (value.runtimeType) {
      case String:
        preferences.setString(key, value as String);
        break;
      case bool:
        preferences.setBool(key, value as bool);
        break;
      case int:
        preferences.setInt(key, value as int);
        break;
      default:
    }
  }

  static Object getValue(String key, Object defaultValue) {
    switch (defaultValue.runtimeType) {
      case String:
        return preferences.getString(key) ?? "";
      case bool:
        return preferences.getBool(key) ?? false;
      case int:
        return preferences.getInt(key) ?? 0;
      default:
        return defaultValue;
    }
  }
}
