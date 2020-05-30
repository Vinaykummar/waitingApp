import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class Customer {
  final String name;
  final String email;
  final String address;
  final String role;
  final String uid;
  final String mobile;
  final bool isSignUpDone;
  final DocumentSnapshot firebaseDocument;

  Customer(
      {@required this.name,
      @required this.mobile,
      @required this.isSignUpDone,
      @required this.email,
      @required this.address,
      @required this.role,
      @required this.uid,
      @required this.firebaseDocument});

  Customer.fromMap(
      Map<String, dynamic> firebaseData, DocumentSnapshot firebaseDocument)
      : this.name = firebaseData['name'],
        this.mobile = firebaseData['mobile'],
        this.email = firebaseData['email'],
        this.address = firebaseData['address'],
        this.role = firebaseData['role'],
        this.uid = firebaseData['uid'],
        this.isSignUpDone = firebaseData['isSignUpDone'],
        this.firebaseDocument = firebaseDocument;

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'role': 'customer',
      'uid': uid,
      'isSignUpDone': isSignUpDone
    };
    return map;
  }
}
