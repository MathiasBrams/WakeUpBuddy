import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WakeUpBuddy/services/auth.dart';
import 'package:meta/meta.dart';
import 'package:WakeUpBuddy/services/api_path.dart';
import 'package:WakeUpBuddy/services/firestore_service.dart';

abstract class Database {
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;
}
