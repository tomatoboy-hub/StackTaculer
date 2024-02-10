import 'package:flutter/material.dart';
import '../common/Footer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeEnabled = false;
  String selectedOption = '12';
  double getFontSize(String selectedOption) {
    switch (selectedOption) {
      case '12':
        return 12.0;
      case '20':
        return 20.0;
      case '28':
        return 28.0;
      default:
        return 12.0; // デフォルトのフォントサイズ
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dark Mode',
              style: Theme.of(context).textTheme.headline6,
            ),
            Switch(
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
                setThemeMode(value);
              },
            ),
            Text(
              'フォントサイズ',
            ),
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue ?? '12';
                });
              },
              items: <String>['12', '20', '28']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),

                );
              }).toList(),

            ),
            Text(
              'サンプルテキスト',
              style: TextStyle(fontSize: getFontSize(selectedOption)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }

  void setThemeMode(bool value) {
    // ダークモードの切り替えロジック
    if (value) {
      // ダークモードを有効にする
      MyApp().setThemeData(ThemeData.dark());
    } else {
      // ダークモードを無効にする
      MyApp().setThemeData(ThemeData.light());
    }
  }
}

extension ThemeExtension on MyApp {
  setThemeData(ThemeData themeData) {
    runApp(
      MaterialApp(
        title: 'Settings',
        theme: themeData,
        home: SettingsScreen(),
      ),
    );
  }
}