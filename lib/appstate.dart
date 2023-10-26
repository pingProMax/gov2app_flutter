

import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  String jwt = "";
  late DateTime jwtEx;
  String app_bulletin = ""; //公告

  String user_name = ""; //用户名
  String plan_name = ""; //套餐信息
  late DateTime expired_at ; //到期时间
  int transfer_enable = 0; //总流量
  String token = ""; //订阅token
  int u = 0; //上传流量
  int d = 0; //下载流量

  String nodeBase64 = ""; //节点列表，订阅处理的原始数据
  String nowLink = ""; //当前选择的节点
  bool startVpn = false; //是否启动
//模式
//节点

}

AppState appState = AppState();