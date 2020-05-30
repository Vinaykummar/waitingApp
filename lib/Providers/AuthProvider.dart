import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stateDemo/Models/User.dart';

class CurrentUserProvider extends ChangeNotifier {
  SharedPreferences sharedPreferences;
  // DocumentSnapshot visitOnGoingDocument;
  // bool _isVisitOnGoing ;
  // int _customerWaitTime;

  User _user;

  User get user => _user;
  // bool get isVisitOnGoing => _isVisitOnGoing;
  // int get customerWaitTime => _customerWaitTime;


  CurrentUserProvider() {
    print('frommm connss');
    _user = User.noUserFound();
    setFromPref();
  }

  setFromPref() async {
    print('called');
    sharedPreferences = await SharedPreferences.getInstance();
    String prefuser = sharedPreferences.getString('user');
    print(prefuser);
    if (prefuser != null) {
      Map<String, dynamic> decoded = json.decode(prefuser);
      User user = User.fromMap(decoded);
      updateCurrentUser(user);
    }
  }

  Future<void> updateCurrentUser(User user) async {
    sharedPreferences = await SharedPreferences.getInstance();
    this._user = user;
    notifyListeners();
    String mappedData = json.encode(user.toJson());
    sharedPreferences.setString('user', mappedData);
    //  QuerySnapshot ongoingvisit = await Firestore.instance
    //     .document(_user.userDocumentPath)
    //     .collection('visits')
    //     .where('status', isEqualTo: 'OnGoing')
    //     .getDocuments();
    // if (ongoingvisit.documents.length > 0) {
    //   this.visitOnGoingDocument = ongoingvisit.documents.first;
    //   print(visitOnGoingDocument.data);
    //   this._isVisitOnGoing = true;
    // }
    // this._isVisitOnGoing = false;
  }

  // timeLeft() async{
  //   final myfrontCustomer = visitOnGoingDocument.data['tokenNo'] - 1;
  //   final myWaitingTime =
  //       myfrontCustomer * visitOnGoingDocument.data['waitingTime'];
  //   final timeOfBooking = DateTime.parse(visitOnGoingDocument.data['time']);

  //   DateTime myApproxTime = timeOfBooking.add(Duration(minutes: myWaitingTime));
  //   Duration timeLeft = myApproxTime.difference(DateTime.now());
  //   print(DateTime.now());
  //   print(timeLeft.inSeconds);
  //   this._customerWaitTime = timeLeft.inSeconds;
  //   notifyListeners();
  // }
}
