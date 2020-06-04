import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stateDemo/Helpers/timeHelpers.dart';
import 'package:stateDemo/Models/VisitModel.dart';

class CustomerServices {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getCustomerVisitDocument(String path) {
    return _firestore
        .document(path)
        .collection('visits')
        .where('status', isEqualTo: 'OnGoing').where('date', isEqualTo: TimeHelpers().todaysDate())
        .snapshots();
  }

  Stream<QuerySnapshot> getNearbyStores() {
    return _firestore
        .collection('customers')
        .where('role', isEqualTo: 'store')
        .snapshots();
  }

  Stream<QuerySnapshot> getStoreBookings(String path) {
    return _firestore
        .document(path)
        .collection('bookings').where('date',isEqualTo: TimeHelpers().todaysDate())
        .limit(1)
        .snapshots();
  }

  Future<void> decreaseCustomerCount(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> deleteInBookedCustomersList(String path) {
    return _firestore.document(path).delete();
  }

  Future<void> deleteVisit(String path) {
    return _firestore.document(path).delete();
  }

  Future<DocumentSnapshot> getCurrentBookedDoc(String path) {
    return _firestore.document(path).get();
  }

  Future<void> increaseCustomerCount(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<DocumentReference> addToBookedCustomersList(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).collection('customers').add(data);
  }

  Future<void> updateBookedCustomer(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> updateVisitedDoc(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<DocumentReference> createVisit(String path, VisitModel visitModel) {
    return _firestore
        .document(path)
        .collection('visits')
        .add(visitModel.toJson());
  }

  Stream<QuerySnapshot> findStores(String query) {
    return _firestore
        .collection('customers')
        .where('role', isEqualTo: 'store')
        .where('keywords', arrayContains: query)
        .snapshots();
  }

  Stream<List<VisitModel>> getMyVisits(String path) {
    return _firestore
        .document(path)
        .collection('visits')
        .orderBy('date', descending: true)
        .snapshots()
        .map((QuerySnapshot visitDocs) => visitDocs.documents
            .map((DocumentSnapshot visitDoc) =>
                VisitModel.fromMap(visitDoc.data, visitDoc))
            .toList());
  }

  Future<QuerySnapshot> getCustomer(String uid) {
   return  _firestore
        .collection('customers')
        .where('uid', isEqualTo: uid)
        .getDocuments();
  }
}
