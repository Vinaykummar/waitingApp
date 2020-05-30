import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StoreModel {
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String role;
  final String uid;
  final String icon;
  final String category;
  final String telephone;
  final String message;
  final List<String> images;
  final List<Map<String, dynamic>> timings;
  final Map<String, dynamic> geoPoint;
  final bool isStoreOpened;
  final DocumentSnapshot firebaseDocument;

  StoreModel(
      {@required this.name,
      @required this.mobile,
      @required this.icon,
      @required this.email,
      @required this.address,
      @required this.role,
      @required this.uid,
      @required this.category,
      @required this.telephone,
      @required this.message,
      @required this.images,
      @required this.timings,
      @required this.geoPoint,
      @required this.firebaseDocument,
      @required this.isStoreOpened});

  StoreModel.fromMap(
      Map<String, dynamic> firebaseData, DocumentSnapshot firebaseDocument)
      : name = firebaseData['name'],
        mobile = firebaseData[' mobile'],
        email = firebaseData['email'],
        address = firebaseData['address'],
        role = firebaseData['role'],
        uid = firebaseData['uid'],
        category = firebaseData['category'],
        icon = firebaseData['icon'],
        telephone = firebaseData['telephone'],
        geoPoint = firebaseData['geoPoint'],
        images = firebaseData['images'],
        timings = firebaseData['timings'],
        isStoreOpened = firebaseData['isStoreOpened'],
        message = firebaseData['message'],
        firebaseDocument = firebaseDocument;

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'role': role,
      'uid': uid,
      'category': category,
      'icon': icon,
      'telephone': telephone,
      'geoPoint': geoPoint,
      'images': images,
      'timings': timings,
      'isStoreOpened': isStoreOpened,
      'message': message
    };
    return map;
  }
}
