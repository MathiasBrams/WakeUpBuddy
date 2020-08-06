

import 'package:WakeUpBuddy/alarm/ListAlarmBuilder.dart';
import 'package:WakeUpBuddy/screens/add_alarm.dart';
import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAlarmScreen()),
              );
            },
            child: Icon(Icons.add, color: Colors.white)),
      body: Container(
          height: 1000,
          child: Center(child: AlarmsList()),
      )
    );
  }
}