import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gov2app_flutter/appstate.dart';
import 'package:gov2app_flutter/const/const.dart';
import 'package:url_launcher/url_launcher.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}


class _UserAccountPageState extends State<UserAccountPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [

          const SizedBox(height: 70),
          Text("欢迎：${appState.user_name}",style: const TextStyle(fontSize: 20),),
          const SizedBox(height: 20),
          Text("套餐信息：${appState.plan_name}",style: const TextStyle(fontSize: 20),),
          const SizedBox(height: 20),
          Text("到期时间：${appState.expired_at}",style: const TextStyle(fontSize: 20),),
          const SizedBox(height: 20),
          Text("软件版本号：${global.Vv}",style: const TextStyle(fontSize: 20),),
          const SizedBox(height: 20),
          GestureDetector(
            child: const Text('购买套餐', style: const TextStyle(color: Colors.blue,fontSize:20)),
            onTap: () {
              _launchInBrowser(Uri.parse(global.PlanUrl));
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), // 设置圆角半径
                    border: Border.all(color: Colors.blue), // 设置边框颜色
                  ), // 设置容器高度
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10.0), // 设置圆角半径
                    value: (appState.u + appState.d) / appState.transfer_enable, // 设置进度值（0.0到1.0之间）
                    backgroundColor: Colors.blue[100], // 设置背景色
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue), // 设置前景色
                  ),
                ),
                Center(

                  child: Text(
                    '${formatNum((appState.u + appState.d)/ 1073741824,2)} GB / ${formatNum(appState.transfer_enable / 1073741824,2)} GB', // 显示的文字内容
                    style: TextStyle(fontSize: 16, color: Colors.black,height: 2), // 文字样式
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 50.0),
        padding:const EdgeInsets.symmetric(horizontal: 10), // 设置底部间距为16.0
        child: ElevatedButton.icon(
          onPressed: () {
            PrefUtil.ClearUserNameAndPasswd();
            SystemNavigator.pop();
          },
          label: const Text('退出账号',style: TextStyle(fontSize: 16, color: Colors.white,height: 2)), // 文字样式),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          icon: const Icon(Icons.undo, size: 18,color: Colors.white,),

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

  formatNum(double num,int postion){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
      //小数点后有几位小数
      return num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }else{
      return num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }
  }


}