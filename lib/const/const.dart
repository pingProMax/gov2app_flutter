
// api------
import 'package:shared_preferences/shared_preferences.dart';

String ApiUrl = "http://192.168.0.102:8080";

class Global {

  String Vv = "v 1.0"; //版本号

  String RegisterUrl = "https://xxxx.com/register"; //注册地址


  String PlanUrl = "https://xxxx.com/user/plan"; //购买套餐地址



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

  static ClearUserNameAndPasswd() async {
    await preferences.remove("userName");
    await preferences.remove("password");
  }
  static SetUserNameAndPasswd(String _userName,_password) async {
    await preferences.setString('userName', _userName);
    await preferences.setString('password', _password);
  }

}
