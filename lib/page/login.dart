// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gov2app_flutter/appstate.dart';
import 'package:gov2app_flutter/page/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gov2app_flutter/const/const.dart';

import 'my_http_request.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isLogButDisabled = false;

  final GlobalKey _formKey = GlobalKey<FormState>();
  late String _userName = "", _password = "";

  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  final List _loginMethod = [
    {
      "title": "facebook",
      "icon": Icons.facebook,
    },
    {
      "title": "google",
      "icon": Icons.fiber_dvr,
    },
    {
      "title": "twitter",
      "icon": Icons.account_balance,
    },
  ];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userName = (PrefUtil.preferences.getString("userName") ?? "")!;
    _password = (PrefUtil.preferences.getString("password") ?? "")!;
  }

  @override
  Widget build(BuildContext context) {
    print(PrefUtil.preferences.getString("userName"));
    print(PrefUtil.preferences.getString("password"));
    if(PrefUtil.preferences.getString("userName") != null && PrefUtil.preferences.getString("password") != null){

      loginHandle();
    }
    return Scaffold(
      body: Form(
        key: _formKey, // 设置globalKey，用于后面获取FormStat
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
            buildTitle(), // Login
            buildTitleLine(), // Login下面的下划线
            const SizedBox(height: 60),
            buildEmailTextField(), // 输入邮箱
            const SizedBox(height: 30),
            buildPasswordTextField(context), // 输入密码
            buildForgetPasswordText(context), // 忘记密码
            const SizedBox(height: 60),
            buildLoginButton(context), // 登录按钮
            const SizedBox(height: 40),
            // buildOtherLoginText(), // 其他账号登录
            // buildOtherMethod(context), // 其他登录方式
            buildRegisterText(context), // 注册
          ],
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('没有账号?'),
            GestureDetector(
              child: const Text('点击注册', style: TextStyle(color: Colors.green)),
              onTap: () {
                _launchInBrowser(Uri.parse(global.RegisterUrl));
              },
            )
          ],
        ),
      ),
    );
  }


  Widget buildOtherMethod(context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(builder: (context) {
        return IconButton(
            icon: Icon(item['icon'],
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              //TODO: 第三方登录方法
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('${item['title']}登录'),
                    action: SnackBarAction(
                      label: '取消',
                      onPressed: () {},
                    )),
              );
            });
      }))
          .toList(),
    );
  }

  Widget buildOtherLoginText() {
    return const Center(
      child: Text(
        '其他账号登录',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        child: CupertinoButton.filled(
          onPressed: isLogButDisabled ? null : () async {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              loginHandle();
            }

          },
          child: const Text('登录'),
        ),
      ),
    );
  }

  //登录处理
  loginHandle() async {

      // 当按钮可操作时才触发回调
      setState(() {
        isLogButDisabled = true; // 禁用按钮
      });


      //TODO 执行登录方法
      Map<String,dynamic> data;
      try {
        data = await MyHttpRequest.myHttpRequest.Login(_userName, _password);
        if(data["code"] != 0){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data["message"].toString()),
            ),
          );
        }else{

          appState.jwt = data["data"]["token"];
          appState.jwtEx = DateTime.parse(data["data"]["expire"]);

          //获取用户信息
          await MyHttpRequest.myHttpRequest.GetSubscribeToken(
              (data) async {
                  if(data["data"]["expired_at"] == null || data["data"]["plan_name"] == ""){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('账号到期或者流量用完，请充值购买:)'),
                      ),
                    );
                    PrefUtil.ClearUserNameAndPasswd();
                    return;
                  }else{
                    appState.token = data["data"]["token"];
                    appState.u = data["data"]["u"];
                    appState.d = data["data"]["d"];
                    appState.transfer_enable = data["data"]["transfer_enable"];
                    appState.expired_at = DateTime.parse(data["data"]["expired_at"]);
                    appState.user_name = data["data"]["user_name"];
                    appState.plan_name = data["data"]["plan_name"];
                    PrefUtil.SetUserNameAndPasswd(_userName,_password);
                  }

              }
          );



          //获取节点列表
          await MyHttpRequest.myHttpRequest.GetNodeInfo(
              appState.token,
                  (data){
                appState.nodeBase64 = data;
              }
          );

          //获取公告
          await MyHttpRequest.myHttpRequest.GetappBul(
                  (data){
                appState.app_bulletin = data;
              }
          );


          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (context) => const UserPage()),(route) => route == null);

        }
      }catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('失败:${e.toString()}'),
          ),
        );
        print('失败:${e.toString()}');
      }finally {
        setState(() {
          isLogButDisabled = false; // 启用按钮
        });
      }


  }

  Widget buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: const Text('无法找回:('),
                  action: SnackBarAction(
                    label: '取消',
                    onPressed: () {},
                  )),
            );
          },
          child: const Text("忘记密码？",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
        controller: TextEditingController(text: _password),
        obscureText: _isObscure, // 是否显示文字
        onSaved: (v) => _password = v!,
        validator: (v) {

          if (v!.isEmpty) {
            return '请输入密码';
          }

        },
        decoration: InputDecoration(
            labelText: "密码",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                // 修改 state 内部变量, 且需要界面内容更新, 需要使用 setState()
                setState(() {

                  _isObscure = !_isObscure;
                  _eyeColor = (_isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color)!;
                });
              },
            )));
  }

  Widget buildEmailTextField() {
    return TextFormField(
      controller: TextEditingController(text: _userName),
      decoration: const InputDecoration(labelText: '用户'),
      validator: (v) {
        var emailReg = RegExp(
            r"^.{6,16}$");
        if (!emailReg.hasMatch(v!)) {

          return '请输入正确的用户';
        }
      },
      onSaved: (v) => _userName = v!,
    );
  }

  Widget buildTitleLine() {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black,
            width: 40,
            height: 2,
          ),
        ));
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 42),
        ));
  }


}