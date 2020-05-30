import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:stateDemo/Helpers/timeHelpers.dart';

class BookingModel {
  final String date;
  final int customers;
  final int waitingTime;
  final bool isBookingOpened;
  final String storeUid;
  final int maxCustomers;
  final String message;
  final DocumentSnapshot firebaseDocument;

  TimeHelpers timeHelpers = TimeHelpers();

  BookingModel(
      {@required this.firebaseDocument,
      @required this.date,
      @required this.customers,
      @required this.waitingTime,
      @required this.isBookingOpened,
      @required this.storeUid,
      @required this.maxCustomers,
      @required this.message});

  BookingModel.fromMap(
      Map<String, dynamic> firebaseData, DocumentSnapshot firebaseDocument)
      : this.date = firebaseData['date'],
        this.customers = firebaseData['customers'],
        this.waitingTime = firebaseData['waitingTime'],
        this.isBookingOpened = firebaseData['isBookingOpened'],
        this.storeUid = firebaseData['storeUid'],
        this.maxCustomers = firebaseData['maxCustomers'],
        this.message = firebaseData['message'],
        this.firebaseDocument = firebaseDocument;

  Map<String, dynamic> toJson() {
    final map = {
      'date': date,
      'customers': customers,
      'waitingTime': waitingTime,
      'isBookingOpened': isBookingOpened,
      'storeUid': storeUid,
      'maxCustomers': maxCustomers,
      'message': message
    };
    return map;
  }
}
