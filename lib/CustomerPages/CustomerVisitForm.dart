import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/AuthProvider.dart';
import 'package:stateDemo/fakedata/fakedata.dart';

class CustomerVisitForm extends StatelessWidget {
  final DocumentSnapshot storeDoc;
  final DocumentSnapshot bookingDoc;
  FakeData fakeData = FakeData();

  CustomerVisitForm({@required this.storeDoc, @required this.bookingDoc});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context);
    TextEditingController gusts = TextEditingController();

    createVisit() async {
      print(bookingDoc.data['customers']);
      Map<String, dynamic> visitDetails = fakeData.genVisit(
          currentUser.user.uid, storeDoc, bookingDoc.data, gusts.text);


      DocumentReference visitedDoc = await Firestore.instance
          .document(currentUser.user.userDocumentPath)
          .collection('visits')
          .add(visitDetails);

      int present = bookingDoc.data['customers'];
      present += 1;
      await Firestore.instance
          .document(bookingDoc.reference.path)
          .setData({'customers': present}, merge: true);

      DocumentReference bookedCustomerDoc = await Firestore.instance
          .document(bookingDoc.reference.path)
          .collection('customers')
          .add(currentUser.user.toJson());

     await Firestore.instance
          .document(bookedCustomerDoc.path)
          .updateData({
       'status': 'OnGoing',
        'tokenNo': visitDetails['tokenNo'],
        'visitDocPath': visitedDoc.path
      });

      await Firestore.instance.document(visitedDoc.path).updateData({
        'bookingDocPath': bookingDoc.reference.path,
        'customerListPath': bookedCustomerDoc.path
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("VisitForm"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Confirming Booking To ${storeDoc.data['name']}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              TextFormField(
                controller: gusts,
                decoration: InputDecoration(labelText: 'Guests Count'),
              ),
              RaisedButton(
                color: Colors.orange,
                onPressed: () async {
                  await createVisit();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Confirm Visit',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
