import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Alarm extends ChangeNotifier {
  Alarm({this.id, this.time, this.active, this.hours, this.minutes, this.docID, this.shortID, this.game});
  final int id;
  final String docID;
  final int shortID;
  final Time time;
  final bool active;
  final int hours;
  final int minutes;
  final String game;

  factory Alarm.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final int hours = data['hours'];
    final int minutes = data['minutes'];
    bool active = data['active'];
    final String game = data['game'];
    

    return Alarm(
      docID: documentId,
      active: active,
      hours: hours,
      minutes: minutes,
      game: game,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'active': active,
      'hours': time.hour,
      'minutes': time.minute,
      'game': game,
      
    };
  }

}