import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class User {
  final String name;
  final String uid;
  final String email;
  final String role;
  final String userDocumentPath;
  final String userDocumentId;
  final GeoPoint geoPoint;
  final bool signUpDone;

  User(
      {@required this.userDocumentPath,
      @required this.userDocumentId,
      @required this.geoPoint,
      @required this.name,
      @required this.signUpDone,
      @required this.uid,
      @required this.email,
      @required this.role});

  User.fromMap(Map<String, dynamic> firebaseData)
      : this.userDocumentPath = firebaseData['documentPath'],
        this.userDocumentId = firebaseData['documentId'],
        this.email = firebaseData['email'],
        this.name = firebaseData['name'],
        this.signUpDone = firebaseData['signUpDone'],
        this.role = firebaseData['role'],
        this.uid = firebaseData['uid'],
        this.geoPoint = firebaseData['geoPoint'];

  User.noUserFound()
      : this.userDocumentPath = 'No User Found',
        this.userDocumentId = 'No User Found',
        this.email = 'No User Found',
        this.name = 'No User Found',
        this.role = 'No User Found',
        this.geoPoint = GeoPoint(50, 50),
        this.signUpDone = false,
        this.uid = 'No User Found';

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'uid': uid,
        'role': role,
        'documentPath': userDocumentPath,
        'documentId': userDocumentId,
        'geoPoint': geoPoint,
        'signUpDone': signUpDone
      };
}
