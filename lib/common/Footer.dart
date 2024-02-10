import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/setting.dart';
class Footer extends StatefulWidget {
  @override
  _Footer createState() => _Footer();
}

class _Footer extends State<Footer> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(), // ホーム画面
    AmountsScreen(), // 金額表示画面
    SettingsScreen(), // 設定画面
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'ホーム',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: '金額表示',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '設定',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        switch (index) {
          case 0:

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => StacktacularApp()));

            break;
          case 1:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AmountsScreen()));

            break;
          case 2:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));

            break;
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('ホーム'),
    );
  }
}

class AmountsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('金額表示'),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('設定'),
    );
  }
}