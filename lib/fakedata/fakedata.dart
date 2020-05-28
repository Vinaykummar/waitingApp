import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';

class FakeData {
  Faker faker = Faker();

  Map<String, dynamic> genCustomer() {
    final map = {
      'name': faker.person.name(),
      'mobile': '8790355805',
      'email': faker.internet.email(),
      'address': faker.address.streetAddress(),
      'role': 'customer',
      'uid': "VvvWyiupZQdLfUFlWo2jAbqqDLH3"
    };
    return map;
  }

  Map<String, dynamic> genStore() {
    final map = {
      'name': faker.company.name(),
      'mobile': '7893090681',
      'email': faker.internet.email(),
      'address': faker.address.streetAddress(),
      'role': 'store',
      'uid': "vJtcVfIlvRdFwrGI1sks8BajcFP2",
      'category': 'Medical',
      'icon':
          'https://images.pexels.com/photos/4350202/pexels-photo-4350202.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'telephone': '040-265487',
      'geoPoint': {
        'geohas': '2547899',
        'latitude': '16.2354',
        'longitude': '58.3695'
      },
      'images': [
        'https://images.pexels.com/photos/3689772/pexels-photo-3689772.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
        'https://images.pexels.com/photos/3689772/pexels-photo-3689772.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
        'https://images.pexels.com/photos/3689772/pexels-photo-3689772.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
        'https://images.pexels.com/photos/3689772/pexels-photo-3689772.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      ],
      'timings': {'Monday': '10AM-6PM'},
      'isStoreOpened': false,
      'message': 'hello customers'
    };
    return map;
  }

  Map<String, dynamic> genVisit(String userid, DocumentSnapshot store, Map<String, dynamic> booking, String visitors) {
    final map = {
      'date' : booking['date'],
      'time': DateTime.now().toString(),
      'tokenNo': booking['patients']+1,
      'waitingTime': booking['waitingTime'],
      'status': 'OnGoing',
      'address': faker.address.streetAddress(),
      'customerUid': userid,
      'storeUid': store['uid'],
      'store': store.data,
      'visitors': visitors
    };
    return map;
  }

  Map<String, dynamic> genBooking() {
    final map = {
      'date' : FieldValue.serverTimestamp(),
      'patients': 5,
      'waitingTime': 20,
      'isBookingOpened': true,
      'storeUid': 'fGRXsdxvajS4EDeeQ5MuMZb8zIo2',
      'message': 'Accepting customers'
    };
    return map;
  }

  // FakeData fakeData = FakeData();
  //   DocumentReference cusDoc;
  //   DocumentReference storeDoc;
  //   DocumentReference bookDoc;

  //   Future uploadCustomer() async {
  //     cusDoc =
  //         await firestore.collection('customers').add(fakeData.genCustomer());
  //     return cusDoc;
  //   }

  //   Future uploadStore() async {
  //     storeDoc =
  //         await firestore.collection('customers').add(fakeData.genStore());
  //     return storeDoc;
  //   }

  //   Future uploadVisit() async {
  //     final doc = await firestore
  //         .document(cusDoc.path)
  //         .collection('visits')
  //         .add(fakeData.genVisit());
  //     return doc;
  //   }

  //   Future uploadBooking() async {
  //     bookDoc = await firestore
  //         .document(storeDoc.path)
  //         .collection('bookings')
  //         .add(fakeData.genBooking());
  //     return bookDoc;
  //   }

  //     Future uploadBookingCustomer() async {
  //     final bookCusDoc = await firestore
  //         .document(bookDoc.path)
  //         .collection('customers')
  //         .add(fakeData.genCustomer());
  //     return bookCusDoc;
  //   }
  //    RaisedButton(
  //                       onPressed: () async {
  //                         await uploadCustomer();
  //                       },
  //                       child: Text("gen Customer"),
  //                     ),
  //                     RaisedButton(
  //                       onPressed: () async {
  //                         await uploadStore();
  //                       },
  //                       child: Text("gen Store"),
  //                     ),
  //                     RaisedButton(
  //                       onPressed: () async {
  //                         await uploadBooking();
  //                       },
  //                       child: Text("gen Booking"),
  //                     ),
  //                     RaisedButton(
  //                       onPressed: () async {
  //                         await uploadVisit();
  //                         await uploadBookingCustomer();
  //                       },
  //                       child: Text("gen visit"),
  //                     )

}



