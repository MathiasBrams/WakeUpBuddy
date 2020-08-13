class APIPath {
  static String alarm(String uid, String alarmId) => 'users/$uid/alarms/$alarmId';
  static String alarms(String uid) => 'users/$uid/alarms';

  static String highscore() => 'highscore';
}
