import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class VisitModel {
  String _customerUid;
  String _time;
  int _tokenNo;
  int _waitingTime;
  String _status;
  String _address;
  String _date;
  String _storeUid;
  String _bookingDocPath;
  String _customerListPath;
  Map<String, dynamic> _store;
  DocumentSnapshot _firebaseDocument;
  DocumentSnapshot storeDoc;
  DocumentSnapshot bookingDoc;

  String get customerUid => _customerUid;

  Map<String, dynamic> get store => _store;

  String get storeUid => _storeUid;

  String get date => _date;

  String get address => _address;

  String get status => _status;

  int get waitingTime => _waitingTime;

  int get tokenNo => _tokenNo;

  String get time => _time;

  String get bookingDocPath => _bookingDocPath;

  String get customerListPath => _customerListPath;

  DocumentSnapshot get firebaseDocument => _firebaseDocument;


  VisitModel({@required this.storeDoc, @required this.bookingDoc});

  VisitModel.fromMap(Map<String, dynamic> firebaseData, DocumentSnapshot firebaseDocument)
      : this._customerUid = firebaseData['customerUid'],
        this._time = firebaseData['time'],
        this._tokenNo = firebaseData['tokenNo'],
        this._waitingTime = firebaseData['waitingTime'],
        this._status = firebaseData['status'],
        this._address = firebaseData['customerUid'],
        this._date = firebaseData['customerUid'],
        this._storeUid = firebaseData['storeUid'],
        this._store = firebaseData['store'],
        this._bookingDocPath = firebaseData['bookingDocPath'],
        this._customerListPath = firebaseData['customerListPath'],
        this._firebaseDocument = firebaseDocument;

  Map<String, dynamic> toJson() {
    final map = {
      'date': bookingDoc.data['date'],
      'time': DateTime.now().toString(),
      'tokenNo': bookingDoc.data['customers'] + 1,
      'waitingTime': bookingDoc.data['waitingTime'],
      'status': 'OnGoing',
      'customerUid': _customerUid,
      'storeUid': storeDoc.data['uid'],
      'store': storeDoc.data,
    };
    return map;
  }

}
