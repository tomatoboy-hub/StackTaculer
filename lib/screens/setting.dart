import 'package:flutter/material.dart';

void main() {
  runApp(MeApp());
}

class MeApp extends StatelessWidget {
  static ThemeData currentTheme = ThemeData.light();
  static double currentFontSize = 12.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings',
      theme: currentTheme,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: MeApp.currentFontSize),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ダークモード'),
            Switch(
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
                setThemeMode(value);
              },
            ),
            Text('フォントサイズ'),
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue ?? '12';
                });
                setFontSize();
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
              style: TextStyle(fontSize: MeApp.currentFontSize),
            ),
          ],
        ),
      ),
    );
  }

  void setThemeMode(bool value) {
    if (value) {
      MeApp.setThemeData(ThemeData.dark());
    } else {
      MeApp.setThemeData(ThemeData.light());
    }
  }

  void setFontSize() {
    double fontSize = getFontSize(selectedOption);
    MeApp.setFontSize(fontSize);
  }

  double getFontSize(String selectedOption) {
    switch (selectedOption) {
      case '12':
        return 12.0;
      case '20':
        return 20.0;
      case '28':
        return 28.0;
      default:
        return 12.0;
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