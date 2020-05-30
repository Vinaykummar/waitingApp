import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{
  String name;
  Timestamp time;
  DocumentSnapshot documentReference;
  DocumentReference documentReferen;

  Customer({this.name,this.time, this.documentReference});

  Map<String, dynamic> toJson() {
    return  {
      'name': name,
      'date': time
    };
  }

 Stream<QuerySnapshot> getVisitCount() {
    return  Firestore.instance.document(documentReference.reference.path).collection('visits').snapshots();
  }

  Future<void> deleteVisit(DocumentSnapshot doc) {
    return Firestore.instance.document(doc.reference.path).delete();
  }



}