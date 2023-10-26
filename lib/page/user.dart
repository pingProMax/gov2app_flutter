import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gov2app_flutter/main.dart';
import 'package:gov2app_flutter/page/user_account.dart';
import 'package:gov2app_flutter/page/user_home.dart';
import 'package:gov2app_flutter/page/v2ray_service.dart';

import '../appstate.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});


  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;
  Color _homeButColor = Colors.blueAccent;
  Color _accountButColor = Colors.black;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _homeButColor = _selectedIndex == 0 ? Colors.blueAccent : Colors.black;
      _accountButColor = _selectedIndex == 1 ? Colors.blueAccent : Colors.black;
    });


  }

  final List<Widget> _bottomNavPages = [];// 底部导航栏各个可切换页面组


  @override
  void initState() {
    super.initState();

    _bottomNavPages..add(const UserHomePage())..add(const UserAccountPage());

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _bottomNavPages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation:50 ,
        notchMargin:10, //缺口边距
        surfaceTintColor:Colors.white, //表面色调颜色
        shadowColor:Colors.black, //阴影颜色
        height:80, //高度
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                iconSize: 30,
                icon:  Icon(
                  Icons.home,
                  color: _homeButColor,
                ),
                onPressed: () {
                  _onItemTapped(0);

                },
              ),
            const SizedBox(), // 增加一些间隔
            IconButton(
              iconSize:30,   // 图标大小
              icon:  Icon(
                Icons.account_circle,
                color: _accountButColor,
              ),
              onPressed: () => _onItemTapped(1),
            ),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        foregroundColor:Colors.white,
        backgroundColor:appState.startVpn ? Colors.blue:Colors.black38,
        shape:const CircleBorder(),
        onPressed: () {

          if(appState.nowLink == ""){

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('请选择节点！'),
              ),
            );
            return;
          }


          if(!appState.startVpn){
            V2rayService(context).connect();
          }else{
            V2rayService(context).stopV2Ray();
          }

          setState(() {
            appState.startVpn = !appState.startVpn;
          });
        },
        child:appState.startVpn ? const Icon(Icons.vpn_key_off,size: 40,):const Icon(Icons.vpn_key,size: 40,),

      ),
      // 设置 floatingActionButton 在底部导航栏中间
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  //
}