import 'package:flutter/material.dart';
import 'package:project1/screens/timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //  Required before using async in main
  await initializeNotifications(); // Call initialization here
  runApp(MainApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showTimerNotification(String time) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'timer_channel',
        'Timer Updates',
        channelDescription: 'Shows running timer',
        importance: Importance.low,
        priority: Priority.high,
        ongoing: true, // Persistent notification
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Timer Running',
    time,
    platformChannelSpecifics,
  );
}

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancel(0);
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Time(), debugShowCheckedModeBanner: false);
  }
}
