import 'package:flutter/material.dart';
import 'package:wetalk/models/user_info.dart';
import 'package:wetalk/pages/contact_page.dart';

class HomePage extends StatefulWidget {
  final UserInfo userInfo;

  HomePage({super.key, required this.userInfo});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages
      ..add(Text('This is page 1'))
      ..add(ContactPage(userId: widget.userInfo.userId))
      ..add(Text('This is page 3'))
      ..add(Text('This is page 4'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '通讯录',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '我',
          ),
        ],
      ),
    );
  }
}
