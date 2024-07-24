import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wetalk/models/user_info.dart';
import 'package:wetalk/pages/home_page.dart';
import 'package:wetalk/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userInfo = await _loadUserInfo();
  runApp(MyApp(userInfo: userInfo));
}

Future<UserInfo?> _loadUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final userInfoJson = prefs.getString('userInfo');
  if (userInfoJson != null) {
    return UserInfo.fromJson(jsonDecode(userInfoJson));
  }
  return null;
}

class MyApp extends StatelessWidget {
  final UserInfo? userInfo;

  MyApp({required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return userInfo == null
                ? MaterialPageRoute(builder: (context) => LoginPage())
                : MaterialPageRoute(
                    builder: (context) => HomePage(userInfo: userInfo!));
          default:
            return null;
        }
      },
    );
  }
}
