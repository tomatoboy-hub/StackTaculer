import 'package:flutter/material.dart';
import '../common/Footer.dart';
import '../database_helper.dart';
void main() {
  runApp(MeApp());
}

class MeApp extends StatelessWidget {
  static ThemeData currentTheme = ThemeData(
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Color(0xFFf2f2f2)),
        color: Color(0xFF4d5d73),
        titleTextStyle: TextStyle(
            color: Color(0xFFbdd9f2),
            fontSize: 24
        )
    ),
  );
  static double currentFontSize = 12.0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SettingsScreen(),
    );
  }
  static setThemeData(ThemeData themeData) {
    currentTheme = themeData;
  }

  static setFontSize(double fontSize) {
    currentFontSize = fontSize;
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
            ElevatedButton(
              onPressed: () => _showDeleteConfirmationDialog(context),
              child: Text('データベース削除'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,// ボタンの背景色を赤に
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('確認'),
          content: Text('データベースを削除してもよろしいですか？'),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop(); // ダイアログを閉じる
                await _resetDatabase(); // データベース削除処理
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _resetDatabase() async {
    // DatabaseHelperを使ってデータベース削除処理を実装
    await DatabaseHelper.instance.resetDatabase();
    // 削除完了後の処理（任意でSnackBar表示など）
    final snackBar = SnackBar(content: Text('データベースを削除しました。'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void setThemeMode(bool value) {
    if (value) {
      MeApp.setThemeData(ThemeData.dark());
    } else {
      MeApp.setThemeData(ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Color(0xFFf2f2f2)),
            color: Color(0xFF4d5d73),
            titleTextStyle: TextStyle(
                color: Color(0xFFbdd9f2),
                fontSize: 24
            )
        ),
      ));
    }
  }
}

extension ThemeExtension on MeApp {
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

