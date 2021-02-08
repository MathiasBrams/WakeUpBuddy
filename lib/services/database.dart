import 'dart:async';

import 'package:WakeUpBuddy/alarm/Alarm_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WakeUpBuddy/services/auth.dart';
import 'package:meta/meta.dart';
import 'package:WakeUpBuddy/services/api_path.dart';
import 'package:WakeUpBuddy/services/firestore_service.dart';

abstract class Database {
  Future<void> setAlarm(Alarm alarm);
  Future<void> deleteAlarm(Alarm alarm);
  
  Stream<List<Alarm>> alarmsStream();
  
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setAlarm(Alarm alarm) async => await _service.setData(
        path: APIPath.alarm(uid, alarm.docID),
        data: alarm.toMap(),
      );

  @override
  Future<void> deleteAlarm(Alarm alarm) async =>
      await _service.deleteData(path: APIPath.alarm(uid, alarm.docID));

  @override
  Stream<List<Alarm>> alarmsStream() => _service.collectionStream(
        path: APIPath.alarms(uid),
        // forsøgt at sorte ud fra id property, men crasher..: sort: (lhs, rhs) => lhs.id.compareTo(rhs.id),
        builder: (data, documentId) => Alarm.fromMap(data, documentId),
        
      );
}
