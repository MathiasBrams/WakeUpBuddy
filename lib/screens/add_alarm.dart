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
import 'package:group_radio_button/group_radio_button.dart';

import '../main.dart';

class AddAlarmScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddAlarmScreenState();
}

class AddAlarmScreenState extends State<AddAlarmScreen> {
  String ringtoneValue = "slow_spring_board";
  String gameValue = "Block Breaker";

  List<String> ringtones = ["slow_spring_board", "alarm_clock"];
  List<String> games = ["Block Breaker", "Laser Defender"];

  final values = List.filled(7, false);
  DateTime _dateTime;
  int newTimeMinute;
  int newTimeHour;
  Day newDay;
  Time newTime;

  int id;
  int shortId;

  String ringtone = 'slow_spring_board';
  String gameScene = '2';
  String channelID;

  Database database;
  Alarm alarm;

  @override
  void initState() {

    super.initState();
  }

  // method to set the game scene number for Alarm, depending on string name choice
  void selectGameScene(String gameValue) {
    if (gameValue == "Block Breaker"){
      gameScene = '2';
    } else if (gameValue == "Laser Defender"){
      gameScene = '5';
    } else {
      gameScene = '1';
    }
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
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              id = _dateTime.microsecondsSinceEpoch;
              // shortId method is used to shorten the id, so it fits to a 32 int max length of ~ 2 mil
              // there is a smarter method im sure... but for now it works
              // maybe .toString().padLeft(9, 0);
              shortId = math.pow(id, 0.6).toInt();
              print(id);
              print(shortId);
              channelID = id.toString();
              // Provider.of<AlarmData>(context, listen: false)
              //     .addAlarm(newTime, shortId);
              await _showDailyAtTime(
                  newTime, shortId, ringtone, channelID, gameScene);
              alarm =
                  Alarm(id: shortId, time: newTime, docID: shortId.toString(), game: gameValue);
              database.setAlarm(alarm);
              print('shit' + alarm.toString());
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 80),
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
          SizedBox(height: 40),
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
              leading: Text('Ringtone', style: TextStyle(fontSize: 16)),
              trailing: Text(ringtoneValue,
                  style: TextStyle(fontWeight: FontWeight.w300)),
              onTap: () async {
                String returnVal = await showDialog(
                context: context,
                child: BuildRadioDialog(selected: ringtoneValue, content: ringtones));
                  setState(() {
                    ringtoneValue = returnVal; 
                    ringtone = ringtoneValue;
                  });}
            ),
          ),
          Card(
            child: ListTile(
              leading: Text('Games ', style: TextStyle(fontSize: 16)),
              trailing: Text(gameValue,
                  style: TextStyle(fontWeight: FontWeight.w300)),
              onTap: () async {
                String returnVal = await showDialog(
                context: context,
                child: BuildRadioDialog(selected: gameValue, content: games));
              setState(() {
                gameValue = returnVal; 
              });
              selectGameScene(gameValue);
              }
            ),
          ),        
          Card(
              child: ListTile(
            leading: Text('Vibration ', style: TextStyle(fontSize: 16)),
            trailing:
                Text(ringtoneValue, style: TextStyle(fontWeight: FontWeight.w300)),
            onTap: () async {
              String returnVal = await showDialog(
                context: context,
                child: BuildRadioDialog(selected: ringtoneValue, content: ringtones));
              setState(() {
                ringtoneValue = returnVal; 
              });}
          )),
        ],
      ),
    );
  }

  Future<void> _showDailyAtTime(Time time, int id, String ringtone,
      String channelID, String gameScene) async {
    var insistentFlag = 4;
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(channelID,
        'name + $channelID', 'info + $channelID',
        icon: 'secondary_icon',
        additionalFlags: Int32List.fromList([insistentFlag]),
        sound: RawResourceAndroidNotificationSound(ringtone),
        playSound: true,
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
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
        platformChannelSpecifics,
        payload: gameScene);
  }
}

class BuildRadioDialog extends StatefulWidget {

  BuildRadioDialog({this.selected, this.content});
  final String selected;
  final List<String> content;

  @override
  _BuildRadioDialogState createState() => _BuildRadioDialogState();
}

class _BuildRadioDialogState extends State<BuildRadioDialog> {

  String selectedID;
  List<String> choices;

  @override
  void initState() {
    super.initState();
    selectedID = widget.selected;
    choices = widget.content;

  }


  @override
  Widget build(BuildContext context) {
                  return AlertDialog(
                    contentTextStyle: TextStyle(fontSize: 20, color: Colors.black),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RadioGroup<String>.builder(
                              spacebetween: 50,
                              groupValue: selectedID,
                              onChanged: (value) => setState(() {
                                selectedID = value;
                                print(selectedID);

                                // close dialog, selectedID gets callbacked
                                Future.delayed(Duration(milliseconds: 300), () {
                                  Navigator.of(context).pop(selectedID);
                                } );
                                
                              }),
                              items: choices,
                              itemBuilder: (item) => RadioButtonBuilder(
                                item,
                                textPosition: RadioButtonTextPosition.left,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
              }
  }