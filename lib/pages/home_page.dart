import 'package:flutter/material.dart';
import 'package:wetalk/models/user_info.dart';

class HomePage extends StatelessWidget {
  final UserInfo? userInfo;

  HomePage({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text(userInfo?.nickName ?? "")),
    );
  }
}
