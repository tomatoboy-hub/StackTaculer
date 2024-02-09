import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

Future<void> scheduleNotification(int id, String title, DateTime scheduledTime) async {
  await AndroidAlarmManager.oneShotAt(
    scheduledTime.add(Duration(days: 7)), // 追加日時から1週間後
    id, // 一意のID
    showNotification, // 通知を表示するコールバック関数
    exact: true,
    wakeup: true,
    alarmClock: true,
    rescheduleOnReboot: true,
    allowWhileIdle: true,
  );
}

// 通知を表示するコールバック関数
void showNotification() {
  var androidDetails = AndroidNotificationDetails(
    'channelId',
    'channelName',
    'channelDescription',
    importance: Importance.max,
    priority: Priority.high,
  );
  var notificationDetails = NotificationDetails(android: androidDetails);
  flutterLocalNotificationsPlugin.show(
    0,
    '忘れていませんか？',
    notificationDetails,
  );
}
