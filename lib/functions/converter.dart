import 'package:cloud_firestore/cloud_firestore.dart';

class Converter {
  static Timestamp toTimestamp(DateTime dateInput) {
    return Timestamp.fromDate(DateTime(dateInput.year, dateInput.month, dateInput.day));
  }

  static DateTime toDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }
}