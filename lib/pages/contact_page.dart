import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:wetalk/models/user_info.dart';

class ContactPage extends StatefulWidget {
  final int userId;

  ContactPage({super.key, required this.userId});

  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  late Future<List<UserInfo>> _friendInfos;

  @override
  void initState() {
    super.initState();
    _friendInfos = _requestContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通讯录'),
      ),
      body: FutureBuilder(
        future: _friendInfos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final friend = snapshot.data![index];
                return Padding(
                  padding: EdgeInsets.only(
                      top: index == 0 ? 0 : 8.0, bottom: 8.0), // 为第一个项目不添加顶部边距
                  child: ListTile(
                    title: Text(friend.nickName),
                    leading: CircleAvatar(
                      radius: 24,
                      child: ClipOval(
                        child: Image.network(
                          friend.avatarUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.account_circle, size: 48);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<UserInfo>> _requestContacts() async {
    final url =
        'https://apifoxmock.com/m1/2415634-2989259-default/contacts?user_id=${widget.userId}';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['code'] == 1) {
        List<UserInfo> friendInfos = [];
        for (var friendInfoJson in jsonResponse['friend_infos']) {
          final friendInfo = UserInfo.fromJson(friendInfoJson);
          friendInfos.add(friendInfo);
        }
        return friendInfos;
      } else {
        throw Exception('未知异常');
      }
    } else {
      throw Exception('网络异常');
    }
  }
}
