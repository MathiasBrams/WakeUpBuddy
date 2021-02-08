import 'dart:typed_data';

import 'package:WakeUpBuddy/alarm/SwitchAlarm.dart';
import 'package:WakeUpBuddy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Alarm_model.dart';

class AlarmTile extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onPressed;
  final Future<void> setAlarm;

  const AlarmTile({
    this.setAlarm,
    this.alarm,
    @required this.onPressed,
  });

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  String selectGameIcon(String game) {
    if (game == 'Block Breaker') {
      return 'assets/images/block_breaker_game.png';
    } else if (game == 'Laser Defender') {
      return 'assets/images/laser_defender_game.png';
    } else {
      return 'assets/images/block_breaker_game.png';
    }
  }

  String _fromIntToDay(int value) {
    if (value == 1) {
      return 'Sunday';
    } else if (value == 2) {
      return 'Monday';
    } else if (value == 3) {
      return 'Tuesday';
    } else if (value == 4) {
      return 'Wednesday';
    } else if (value == 5) {
      return 'Thursday';
    } else if (value == 6) {
      return 'Friday';
    } else if (value == 7) {
      return 'Saturday';
    } 
  }

  

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Image.asset(selectGameIcon(alarm.game)),
        title: Text('${_toTwoDigitString(alarm.hours)}:${_toTwoDigitString(alarm.minutes)}'),
        // :${_toTwoDigitString(alarm.minutes)}'),
        subtitle: Text(alarm.game ?? 'Alarm'),
        onTap: onPressed,
        trailing: SwitchAlarm(alarm),
      ));
  }
}