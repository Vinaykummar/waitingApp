import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Models/VisitModel.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Services/CustomerServices.dart';
import 'package:stateDemo/fakedata/fakedata.dart';

class CustomerVisitForm extends StatelessWidget {
  final DocumentSnapshot storeDoc;
  final DocumentSnapshot bookingDoc;
  FakeData fakeData = FakeData();
  CustomerServices customerServices = CustomerServices();

  CustomerVisitForm({@required this.storeDoc, @required this.bookingDoc});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    TextEditingController gusts = TextEditingController();

    VisitModel visitModel =
        VisitModel(storeDoc: storeDoc, bookingDoc: bookingDoc);

    createVisit() async {


      DocumentReference visitedDoc = await customerServices.createVisit(
          currentUser.user.userDocumentPath, visitModel);

      int present = bookingDoc.data['customers'];
      present += 1;
      await customerServices.increaseCustomerCount(
          bookingDoc.reference.path, {'customers': present});

      print(bookingDoc.reference.path);
      print(currentUser.user.toJson());

      DocumentReference bookedCustomerDoc =

          await customerServices.addToBookedCustomersList(
              bookingDoc.reference.path, currentUser.user.toJson());



      await customerServices.updateBookedCustomer(bookedCustomerDoc.path, {
        'status': 'OnGoing',
        'tokenNo': visitModel.toJson()['tokenNo'],
        'visitDocPath': visitedDoc.path
      });

      await customerServices.updateVisitedDoc(visitedDoc.path, {
        'bookingDocPath': bookingDoc.reference.path,
        'customerListPath': bookedCustomerDoc.path
      });

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("VisitForm", style: TextStyle(color: Colors.black),),
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
