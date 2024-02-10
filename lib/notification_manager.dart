import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();



Future<void> scheduleNotification() async {
  final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  await AndroidAlarmManager.oneShotAt(
    DateTime.now().add(Duration(seconds: 10)), // 追加日時から1週間後
    notificationId,
    showNotification, // 通知を表示するコールバック関数
    exact: true,
    wakeup: true,
  );
}

// 通知を表示するコールバック関数
void showNotification() {
  var androidDetails = AndroidNotificationDetails(
    'channelId',
    'channelName',
    channelDescription: 'channelDescription',
    importance: Importance.max,
    priority: Priority.high,
  );
  var notificationDetails = NotificationDetails(android: androidDetails);
  flutterLocalNotificationsPlugin.show(
    0, // 通知ID
    '忘れていませんか?', // 通知タイトル
    'こちらの本をチェックしましたか？', // 通知本文
    notificationDetails, // 通知詳細
  );
}
