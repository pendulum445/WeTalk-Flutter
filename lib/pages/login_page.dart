import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:wetalk/models/user_info.dart';
import 'package:wetalk/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: '用户名'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '请输入用户名';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '密码'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      await _requestLogin(context, _username, _password);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                            .showSnackBar(SnackBar(
                                content: Text(e.toString()),
                                duration: Duration(seconds: 2)));
                      }
                    }
                  }
                },
                child: Text('登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestLogin(
      BuildContext context, username, String password) async {
    const url = 'https://apifoxmock.com/m1/2415634-2989259-default/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'nick_name': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['code'] == 1) {
        _saveUserInfo(jsonResponse['user_info']);
        final userInfo = UserInfo.fromJson(jsonResponse['user_info']);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              _scaffoldKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => HomePage(userInfo: userInfo)),
              (Route<dynamic> route) => false);
        }
      } else {
        throw Exception('用户名或密码错误');
      }
    } else {
      throw Exception('网络异常');
    }
  }

  Future<void> _saveUserInfo(Map<String, dynamic> userInfoJson) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', jsonEncode(userInfoJson));
  }
}
