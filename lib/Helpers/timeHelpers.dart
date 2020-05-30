import 'package:cloud_firestore/cloud_firestore.dart';

class TimeHelpers {
  String timestampToString(Timestamp time) {
    return DateTime.parse(time.toDate().toString()).toIso8601String();
  }

  String todaysDate() {
      return '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    }
  
}