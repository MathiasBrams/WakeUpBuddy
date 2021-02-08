import 'dart:typed_data';

import 'package:WakeUpBuddy/alarm/Alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:WakeUpBuddy/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hello_world/utils/notificationHelper.dart';

class SwitchAlarm extends StatefulWidget {
  SwitchAlarm(this.alarm);
  final Alarm alarm;
  @override
  _SwitchAlarmState createState() =>
      _SwitchAlarmState();
}

class _SwitchAlarmState extends State<SwitchAlarm> {
  bool isSwitched = true;

  Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> showDailyAtTime(Time time, int id) async {
          var insistentFlag = 4;
          var vibrationPattern = Int64List(4);
          vibrationPattern[0] = 0;
          vibrationPattern[1] = 1000;
          vibrationPattern[2] = 5000;
          vibrationPattern[3] = 2000;
          var androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'repeatDailyAtTime channel id',
              'repeatDailyAtTime channel name',
              'repeatDailyAtTime description',
              icon: 'secondary_icon',
              additionalFlags: Int32List.fromList([insistentFlag]),
              sound: RawResourceAndroidNotificationSound('slow_spring_board'),
              largeIcon: DrawableResourceAndroidBitmap('sample_large_icon'),
              vibrationPattern: vibrationPattern,
              enableLights: true,
              showWhen: true,
              timeoutAfter: 200000,
              importance: Importance.Max,
              priority: Priority.High,
              color: const Color.fromARGB(255, 255, 0, 0),
              ledColor: const Color.fromARGB(255, 255, 0, 0),
              ledOnMs: 5000,
              ledOffMs: 500);
          var iOSPlatformChannelSpecifics = IOSNotificationDetails();
          var platformChannelSpecifics = NotificationDetails(
              androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.showDailyAtTime(
              id,
              'Rise and shine buddy',
              'Snoozing is loosing!',
              time,
              platformChannelSpecifics);
        }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Switch(
              value: isSwitched,
              onChanged: (value) {
                if (!value) {
                  // cancels the scheduled alarm
                  _cancelNotification(widget.alarm.shortID);
                } else {
                  // sets the alarm back at the same time and the same id
                  showDailyAtTime(widget.alarm.time, widget.alarm.shortID);
                }
                setState(() {
                  isSwitched = value;
                }
                
                );
              },
              activeTrackColor: Colors.blue[200],
              activeColor: Colors.blue,
            ),
    );
  }
}
