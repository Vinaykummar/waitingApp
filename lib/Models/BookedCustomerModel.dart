import 'package:cloud_firestore/cloud_firestore.dart';

class BookedCustomerModel {
  String _name;
  String _uid;
  String _email;
  String _role;
  String _status;
  String _tokenNo;
  String _visitDocPath;
  DocumentSnapshot _firebaseDocument;

  String get name => _name;

  String get tokenNo => _tokenNo;

  String get status => _status;

  String get role => _role;

  String get email => _email;

  String get uid => _uid;

  String get visitDocPath => _visitDocPath;

  DocumentSnapshot get firebaseDocument => _firebaseDocument;

  BookedCustomerModel.fromMap(
      Map<String, dynamic> firebaseData, DocumentSnapshot firebaseDocument)
      : this._name = firebaseData['name'],
        this._email = firebaseData['email'],
        this._role = firebaseData['role'],
        this._status = firebaseData['status'],
        this._tokenNo = firebaseData['tokenNo'],
        this._uid = firebaseData['uid'],
        this._visitDocPath = firebaseData['visitDocPath'],
        this._firebaseDocument = firebaseDocument;

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'uid': uid,
        'role': role,
        'visitDocPath': visitDocPath,
        'status': status,
        'tokenNo': tokenNo,
      };

}
