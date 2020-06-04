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

  Stream<QuerySnapshot> getAllBookedCustomers(String path) {
    return _firestore
        .document(path)
        .collection('customers')
        .snapshots();
  }

  Stream<DocumentSnapshot> getMystore(String path) {
    return _firestore.document(path).snapshots();
  }

  Future<void> increaseCustomerCount(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> decreaseCustomerCount(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<QuerySnapshot> getBookedCustomers(String path) {
    return _firestore.document(path).collection('customers').getDocuments();
  }

  Future<void> updateVisitorsTokenNo(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> updateBookedCustomersTokenNo(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> updateBookingWaitingTime(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> updateBookingMessage(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> openBooking(String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> closeBooking(String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> closeStore(String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> openStore(String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<DocumentReference> addbooking(String path, BookingModel bookingModel) {
    return _firestore
        .document(path)
        .collection('bookings')
        .add(bookingModel.toJson());
  }

  Future<void> updateVisitorsStatus(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }

  Future<void> updateBookedCustomersStatus(
      String path, Map<String, dynamic> data) {
    return _firestore.document(path).setData(data, merge: true);
  }
}
