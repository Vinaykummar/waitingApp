import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stateDemo/Models/VisitModel.dart';

class CustomerServices {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getCustomerVisitDocument(String path) {
    return _firestore
        .document(path)
        .collection('visits')
        .where('status', isEqualTo: 'OnGoing')
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
        .collection('bookings')
        .limit(1)
        .snapshots();
  }

  Future<DocumentSnapshot> decreaseCustomerCount(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<DocumentSnapshot> deleteInBookedCustomersList(String path) {
    return Firestore.instance.document(path).delete();
  }

  Future<DocumentSnapshot> deleteVisit(String path) {
    return Firestore.instance.document(path).delete();
  }

  Future<DocumentSnapshot> getCurrentBookedDoc(String path) {
    return Firestore.instance.document(path).get();
  }

  Future<DocumentSnapshot> increaseCustomerCount(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<DocumentReference> addToBookedCustomersList(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).collection('customers').add(data);
  }

  Future<DocumentReference> updateBookedCustomer(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).collection('customers').add(data);
  }

  Future<DocumentReference> updateVisitedDoc(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).collection('customers').add(data);
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
}
