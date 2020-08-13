import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:WakeUpBuddy/alarm/Alarm_data_list.dart';
import 'package:WakeUpBuddy/alarm/Alarm_tile.dart';
import 'package:WakeUpBuddy/alarm/ListAlarmBuilder.dart';
import 'package:WakeUpBuddy/games/snaake/lib/snaake_game_main.dart';
import 'package:WakeUpBuddy/landing_page.dart';
import 'package:WakeUpBuddy/screens/add_alarm.dart';
import 'package:WakeUpBuddy/screens/alarm_page.dart';
import 'package:WakeUpBuddy/screens/edit_alarm.dart';
import 'package:WakeUpBuddy/screens/game_overview_page.dart';
import 'package:WakeUpBuddy/screens/settings_page.dart';
import 'package:WakeUpBuddy/services/auth.dart';
import 'package:WakeUpBuddy/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:WakeUpBuddy/alarm/Alarm_model.dart';
import 'package:animations/animations.dart';

import 'alarm/SwitchAlarm.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

/// IMPORTANT: running the following code on its own won't work as there is setup required for each platform head project.
/// Please download the complete example app from the GitHub repository where all the setup has been done
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
        child: MaterialApp(
          theme: ThemeData(
              primaryColor: Colors.blue, accentColor: Colors.blue[200]),
          home: LandingPage(),
        ));
  }
}


class HomePage extends StatefulWidget {
  HomePage({this.alarm});
  Alarm alarm;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // pages for navigation
  int pageIndex = 0;

  List<Widget> pageList = <Widget>[
    AlarmPage(),
    GamesPage(),
  ];

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
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SnakeGame()
                      // (receivedNotification.payload),
                      ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SnakeGame()),
      );
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
    return ChangeNotifierProvider(
        create: (context) => AlarmData(),
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue[400], accentColor: Colors.blue[200]),
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Wake Up Buddy',
              style: TextStyle(color: Colors.grey[200], fontSize: 22)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings, color: Colors.grey[200]), onPressed: () => SettingsScreen.show(context, database: Provider.of<Database>(context, listen: false), user: Provider.of<User>(context, listen: false)),
                  ),
          ],
        ),
        body: PageTransitionSwitcher(
        duration: Duration(milliseconds: 1200),
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pageList[pageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (int newValue) {
          setState(() {
            pageIndex = newValue;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            title: Text('Alarms'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            title: Text('Games'),
          ),
        ],
      ),
        ),
        )
    );
  }

  Future<void> _cancelNotification(dynamic id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future<void> _scheduleNotification() async {
    var insistentFlag = 4;
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
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
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Rise and shine buddy',
        'Play the game and get moving!',
        scheduledNotificationDateTime,
        platformChannelSpecifics);

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
          'Play the game and get moving!',
          time,
          platformChannelSpecifics);
    }
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _showWeeklyAtDayAndTime(Time time) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'show weekly title',
        'Weekly notification shown on Monday at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        Day.Friday,
        time,
        platformChannelSpecifics);
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }
}

