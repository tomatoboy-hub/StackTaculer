import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestExactAlarmsPermission();

  await AndroidAlarmManager.initialize();

  runApp(StacktacularApp());
}

class StacktacularApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StackTaculer',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFbf7449),

          //splashColor: Color(0xFF401b13)
        ),
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Color(0xFFf2f2f2)),
          color: Color(0xFF4d5d73),
          titleTextStyle: TextStyle(
            color: Color(0xFFbdd9f2),
            fontSize: 24
          )
        ),
        cardTheme: CardTheme(
          color: Color(0xFFf2f2f2)
        )
      ),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Color(0xFFf2f2f2)
          ),
          titleTextStyle: TextStyle(
            color: Color(0xFF4d5d73)
          )
        ),
        cardTheme: CardTheme(
          color: Color(0xFF0d0d0d)
        ),
      ),
      home: HomeScreen(),
    );
  }
}
