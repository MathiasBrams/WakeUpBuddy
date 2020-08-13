

import 'package:WakeUpBuddy/alarm/Alarm_model.dart';
import 'package:WakeUpBuddy/alarm/Alarm_tile.dart';
import 'package:WakeUpBuddy/alarm/ListAlarmBuilder.dart';
import 'package:WakeUpBuddy/alarm/list_items_builder.dart';
import 'package:WakeUpBuddy/screens/add_alarm.dart';
import 'package:WakeUpBuddy/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
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
      body: Container(
          height: 1000,
          child: Center(
            child: StreamBuilder<List<Alarm>>(
              stream: database.alarmsStream(),
              builder: (context, snapshot) {
                
                
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListItemsBuilder<Alarm>(
                    snapshot: snapshot,
                    itemBuilder: (context, alarm) => AlarmTile(
                      alarm: alarm,
                      onPressed: () {},
                    )
                  )
                );
              }
            )
          )
      )
    );
  }
}