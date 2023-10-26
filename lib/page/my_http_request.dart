import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:gov2app_flutter/appstate.dart';
import 'package:gov2app_flutter/const/const.dart';
import 'package:http/http.dart' as http;

class MyHttpRequest {
  static MyHttpRequest myHttpRequest = MyHttpRequest();

  String jwt = "";

  //登录
  Future<Map<String,dynamic>> Login(String userName,passwd) async {
    final dio = Dio();

    final response = await dio.post(
        global.loginApi,
        data:{
          'UserName': userName,
          'Passwd': passwd,
        },
    );
    print(response.data);
    if(response.data["code"] == 0){
      jwt = response.data["data"]["token"];
    }

    return response.data;
  }

  //获取用户订阅Token
  Future<void> GetSubscribeToken(Function call) async {
    final dio = Dio();
    final response = await dio.post(
      global.getUserInfoApi,
      data:{

      },
      queryParameters: {
        "token":jwt,
      }

    );
    print(response.data);
    if(response.data["code"] == 0){
      call(response.data);
    }

  }

  //获取节点列表
  Future<void> GetNodeInfo(token,Function call) async {
    final dio = Dio();
    final response = await dio.get(
        // ignore: prefer_interpolation_to_compose_strings
        global.subApi + '?token=${token}&flag=v2rayn&flag_info_hide=true',
    );
    if(response.data is String){
      call(response.data);
    }else{
      throw FormatException("未获取到订阅信息");
    }

  }

  //获取公告
  Future<void> GetappBul(Function call) async {
    final dio = Dio();
    print(global.appBulApi);
    final response = await dio.get(
        global.appBulApi,
        queryParameters: {
          "token":jwt,
        }
    );
    print(response.data);
    if(response.data["code"] == 0){
      call(response.data["data"]["data"]);
    }

  }

}