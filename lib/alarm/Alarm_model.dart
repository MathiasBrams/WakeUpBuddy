import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class Alarm {
  Alarm({this.id, @required this.time, this.active});
  final int id;
  Time time;
  bool active;

}