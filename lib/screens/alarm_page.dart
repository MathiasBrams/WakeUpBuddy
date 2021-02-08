

import 'package:WakeUpBuddy/alarm/Alarm_model.dart';
import 'package:WakeUpBuddy/alarm/Alarm_tile.dart';
import 'package:WakeUpBuddy/alarm/ListAlarmBuilder.dart';
import 'package:WakeUpBuddy/alarm/list_items_builder.dart';
import 'package:WakeUpBuddy/screens/add_alarm.dart';
import 'package:WakeUpBuddy/screens/unityPage.dart';
import 'package:WakeUpBuddy/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'edit_alarm.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {

  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push((MaterialPageRoute(builder: (BuildContext context) => UnityTestingWrapper(game: 'Level 2', scene: 5, payload: '2') ))
                );
              },
            )
          ],
        ),
      );
    });
  }

  // hvad gør den her helt specielt og hvorfor snakegame?.. action ved payload trigger?

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.of(context).push((MaterialPageRoute(builder: (BuildContext context) => UnityTestingWrapper(game: 'Level 2', payload: payload) )));
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAlarmScreen()),
              );
            },
            child: Icon(Icons.add, color: Colors.white)),
      body: ListView(
        children: <Widget> [StreamBuilder<List<Alarm>>(
              stream: database.alarmsStream(),
              builder: (context, snapshot) {             
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListItemsBuilder<Alarm>(
                    snapshot: snapshot,
                    itemBuilder: (context, alarm) => AlarmTile(
                      alarm: alarm,
                      onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAlarmScreen(alarm),
                        ),
                      );},
                    )
                  )
                );
              }
      )
        ])
    );
  }
}