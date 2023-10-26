import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:gov2app_flutter/appstate.dart';
import 'package:gov2app_flutter/page/v2ray_service.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}


enum SingingCharacter { noall, all }
class _UserHomePageState extends State<UserHomePage> {

  SingingCharacter? _character = SingingCharacter.noall;

  // 下拉菜单选项
  final List<String> _dropdownItems = [];

  Map<String,String> v2rayInfo = {} ;

  String? _selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // base64解码
    List<int> decodedBytes = base64.decode(appState.nodeBase64);
    String decodeStr = utf8.decode(decodedBytes); // 将字节转换为字符串

    decodeStr.split("\n").forEach((element) {
      if(element != ""){

        V2RayURL parser = FlutterV2ray.parseFromURL(element);
        _dropdownItems.add(parser.remark);
        // print(parser.getFullConfiguration());
        v2rayInfo[parser.remark] = element;

      }
    });




  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
            const SizedBox(height: 70),
            Image.asset(
              'assets/images/logo.png', // 替换为你的Logo图片路径
              width: 100.0, // 设置Logo的宽度
              height: 100.0, // 设置Logo的高度
            ),
            const SizedBox(height: 70),
            const Text("节点选择", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('请选择节点'),                            // 下拉框上的提示文字
              underline: Container(height: 1, color: Colors.green), // 下面的横线
              itemHeight: 60,                                       // 下拉菜单的每一项的宽度
              // menuMaxHeight: 2000,                                   // 下拉菜单的整体宽度，显示不下可滚动
              borderRadius: BorderRadius.circular(10),              // 边框圆角的半径
              padding:  const EdgeInsets.all(10.0),
              value: _selectedItem, // 当前选中的值
              items: _dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (selectedItem) {
                // 当选择项发生变化时，更新状态，触发UI重绘
                setState(() {
                  _selectedItem = selectedItem!;
                  appState.nowLink = v2rayInfo[selectedItem]!;

                });

                if(appState.startVpn){
                  V2rayService(context).connect();
                }else{
                  V2rayService(context).stopV2Ray();
                }
              },
            ),
            // ListTile(
            //   title: const Text('绕过大陆'),
            //   leading: Radio<SingingCharacter>(
            //     value: SingingCharacter.noall,
            //     groupValue: _character,
            //     onChanged: (SingingCharacter? value) {
            //       setState(() {
            //         _character = value;
            //       });
            //     },
            //   ),
            // ),
            // ListTile(
            //   title: const Text('全局'),
            //   leading: Radio<SingingCharacter>(
            //     value: SingingCharacter.all,
            //     groupValue: _character,
            //     onChanged: (SingingCharacter? value) {
            //       setState(() {
            //         _character = value;
            //       });
            //     },
            //   ),
            // ),
            const SizedBox(height: 20),
            MarkdownBody(data: appState.app_bulletin),

          ],
      ),
    );

  }


}