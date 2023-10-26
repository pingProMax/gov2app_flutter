
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:gov2app_flutter/appstate.dart';



class V2rayService {

  BuildContext context;
  V2rayService(this.context){
    flutterV2ray.initializeV2Ray(); //初始化函数
  }
  late final FlutterV2ray flutterV2ray = FlutterV2ray(
    onStatusChanged: (status) {
      // v2rayStatus.value = status;
    },
  );

  var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());

  void connect() async {
    try {
      print("开启v2ray:${appState.nowLink}");
      V2RayURL parser = FlutterV2ray.parseFromURL(appState.nowLink);
      int ms = await flutterV2ray.getServerDelay(config: parser.getFullConfiguration());
      print(ms);
      if (await flutterV2ray.requestPermission()) {
        await flutterV2ray.startV2Ray(
          remark: parser.remark,
          // The use of parser.getFullConfiguration() is not mandatory,
          // and you can enter the desired V2Ray configuration in JSON format
          config: parser.getFullConfiguration(),
          blockedApps: null,
          proxyOnly: false,
        );
      }else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permission Denied'),
            ),
          );
        }
      }
    }catch (e) {
      print("启动v2ray错误：${e.toString()}");
    }
  }

  void stopV2Ray() async {
    print("关闭v2ray");
    // Disconnect
    await flutterV2ray.stopV2Ray();
  }


}