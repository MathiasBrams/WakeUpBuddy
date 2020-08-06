import 'package:WakeUpBuddy/alarm/Alarm_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmData extends ChangeNotifier{
  List<Alarm> _alarms = [
    Alarm(time: Time(13, 45)),
    Alarm(time: Time(14, 00)),
  ];

  UnmodifiableListView<Alarm> get alarms {
    return UnmodifiableListView(_alarms);
  }



  int get alarmCount {
    return _alarms.length;
  }

  void addAlarm(Time newTime, int id) {
    final alarm = Alarm(time: newTime, id: id);
    _alarms.add(alarm);
    notifyListeners();
  }

  // void updateTask(Task task) {
  //   task.toggleDone();
  //   notifyListeners();
  // }

  // void deleteTask(Task task) {
  //   _tasks.remove(task);
  //   notifyListeners();
  // }
}
