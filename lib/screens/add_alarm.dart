import 'dart:typed_data';

import 'package:WakeUpBuddy/alarm/Alarm_data_list.dart';
import 'package:WakeUpBuddy/alarm/Alarm_model.dart';
import 'package:WakeUpBuddy/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'dart:math' as math;

import '../main.dart';

class AddAlarmScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddAlarmScreenState();
}

class AddAlarmScreenState extends State<AddAlarmScreen> {
  final values = List.filled(7, false);
  DateTime _dateTime;
  int newTimeMinute;
  int newTimeHour;
  Day newDay;
  Time newTime;

  int id;
  int shortId;

  Database database;
  Alarm alarm;

  @override
  void initState() {
    super.initState();
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  printIntAsDay(int day) {
    print(
        'Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
  }

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tueday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<Database>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Alarm', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check), onPressed: () async {
                  id = _dateTime.microsecondsSinceEpoch;
                  // shortId method is used to shorten the id, so it fits to a 32 int max length of ~ 2 mil
                  // there is a smarter method im sure... but for now it works
                  // maybe .toString().padLeft(9, 0);
                  shortId = math.pow(id, 0.6).toInt();
                  print(id);
                  print(shortId);
                  // Provider.of<AlarmData>(context, listen: false)
                  //     .addAlarm(newTime, shortId);
                  await _showDailyAtTime(newTime, shortId);
                  alarm = Alarm(id: shortId, time: newTime, docID: shortId.toString());
                  database.setAlarm(alarm);
                  print('shit' + alarm.toString());
                  Navigator.pop(context);
                },)
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TimePickerSpinner(
                is24HourMode: true,
                secondsInterval: 5,
                // normalTextStyle: TextStyle(
                //   fontSize: 24,
                //   color: Colors.deepOrange
                // ),
                highlightedTextStyle:
                    TextStyle(fontSize: 40, color: Colors.blue[300]),
                spacing: 50,
                itemHeight: 50,
                // isForce2Digits: true,
                onTimeChange: (time) {
                  setState(() {
                    _dateTime = time;
                    newTimeMinute = _dateTime.minute;
                    newTimeHour = _dateTime.hour;
                    newTime = Time(newTimeHour, newTimeMinute);
                    print(
                        '${_toTwoDigitString(newTime.hour)}:${_toTwoDigitString(newTime.minute)}');
                  });
                },
              ),
              // WeekdaySelector(
              //   onChanged: (int day) {
              //     setState(() {
              //       // Use module % 7 as Sunday's index in the array is 0 and
              //       // DateTime.sunday constant integer value is 7.

              //       // We "flip" the value in this example, but you may also
              //       // perform validation, a DB write, an HTTP call or anything
              //       // else before you actually flip the value,
              //       // it's up to your app's needs.
              //       values[day % 7] = !values[day % 7];
              //       printIntAsDay(day);
              //     });
              //   },
              //   values: values,

              //   ),
              Card(
                  child: ListTile(
                      leading: Text('Ringtone ', style: TextStyle(fontSize: 16)),
                      trailing: 
                          Text('Standard', style: TextStyle(fontWeight: FontWeight.w300)),
                      )),
              Card(
                  child: ListTile(
                      leading: Text('Vibration ', style: TextStyle(fontSize: 16)),
                      trailing: 
                          Text('Standard', style: TextStyle(fontWeight: FontWeight.w300)),
                      )),
              Card(
                  child: ListTile(
                      leading: Text('Game ', style: TextStyle(fontSize: 16)),
                      trailing: 
                          Text('Snake', style: TextStyle(fontWeight: FontWeight.w300)),
                      )),
              Card(
                  child: ListTile(
                      leading: Text('Repeat ', style: TextStyle(fontSize: 16)),
                      trailing: 
                          Text('Everyday', style: TextStyle(fontWeight: FontWeight.w300)),
                      )),
            ]));
  }

  Future<void> _showDailyAtTime(Time time, int id) async {
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
        'Play the game or suffer :-)',
        time,
        platformChannelSpecifics);
    print('this is' + id.toString());
  }
}
