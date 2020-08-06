import 'package:WakeUpBuddy/alarm/Alarm_data_list.dart';
import 'package:WakeUpBuddy/alarm/Alarm_tile.dart';
import 'package:WakeUpBuddy/screens/edit_alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmData>(
      builder: (context, alarmData, child) {
        return ListView.builder(
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            final alarm = alarmData.alarms[index];
            return AlarmTile(
              alarm: alarm,
              onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAlarmScreen(alarm),
                  ),
                );},
              // isChecked: task.isDone,
              // checkboxCallback: (checkboxState) {
              //   taskData.updateTask(task);
              // },
              // longPressCallback: () {
              //   taskData.deleteTask(task);
              // },
            );
          },
          itemCount: alarmData.alarmCount,
        );
      },
    );
  }
}
