import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stateDemo/Models/BookedCustomerModel.dart';
import 'package:stateDemo/Models/BookingModel.dart';

class StoreServices {
  Firestore _firestore = Firestore.instance;

  Stream<List<BookingModel>> getTodaysBookingDocument(
      String path, String uid, String date) {
    return _firestore
        .document(path)
        .collection('bookings')
        .where('storeUid', isEqualTo: uid)
        .where('date', isEqualTo: date)
        .where('isBookingOpened', isEqualTo: true)
        .snapshots()
        .map((QuerySnapshot bookingDocs) => bookingDocs.documents
            .map((DocumentSnapshot bookingDoc) =>
                BookingModel.fromMap(bookingDoc.data, bookingDoc))
            .toList());
  }

  Stream<List<BookingModel>> getAllBookings(String path, String uid) {
    return _firestore
        .document(path)
        .collection('bookings')
        .where('storeUid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot bookingDocs) => bookingDocs.documents
            .map((DocumentSnapshot bookingDoc) =>
                BookingModel.fromMap(bookingDoc.data, bookingDoc))
            .toList());
  }

  Stream<List<BookedCustomerModel>> getAllBookedCustomers(String path) {
    return _firestore
        .document(path)
        .collection('customers')
        .orderBy('tokenNo', descending: false)
        .snapshots()
        .map((QuerySnapshot bookedCustomersDocs) => bookedCustomersDocs
            .documents
            .map((DocumentSnapshot bookedCustomersDoc) =>
                BookedCustomerModel.fromMap(
                    bookedCustomersDoc.data, bookedCustomersDoc))
            .toList());
  }

  Stream<DocumentSnapshot> getMystore(String path) {
    return _firestore.document(path).snapshots();
  }

  Future<DocumentSnapshot> increaseCustomerCount(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<DocumentSnapshot> decreaseCustomerCount(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> getBookedCustomers(String path) {
    return _firestore.document(path).collection('customers').getDocuments();
  }

  Future<QuerySnapshot> updateVisitorsTokenNo(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> updateBookedCustomersTokenNo(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> updateBookingWaitingTime(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> updateBookingMessage(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> openBooking(String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> closeBooking(String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> closeStore(String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> openStore(String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<DocumentReference> addbooking(String path, BookingModel bookingModel) {
    return _firestore
        .document(path)
        .collection('bookings')
        .add(bookingModel.toJson());
  }

  Future<QuerySnapshot> updateVisitorsStatus(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> updateBookedCustomersStatus(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }
}
