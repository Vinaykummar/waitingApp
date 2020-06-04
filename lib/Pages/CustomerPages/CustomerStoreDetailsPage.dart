import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stateDemo/Services/CustomerServices.dart';

import 'CustomerVisitForm.dart';

class CustomerStoreDetailsPage extends StatelessWidget {
  final DocumentSnapshot storeDoc;

  CustomerStoreDetailsPage({this.storeDoc});

  CustomerServices customerServices = CustomerServices();

  @override
  Widget build(BuildContext context) {
    return StoreWidget(gotStores: storeDoc);
  }
}

class StoreWidget extends StatelessWidget {
  StoreWidget({Key key, @required this.gotStores}) : super(key: key);

  final DocumentSnapshot gotStores;
  CustomerServices customerServices = CustomerServices();

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                gotStores.data['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                gotStores.data['address'],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 5,
              ),
              gotStores.data['isStoreOpened'] == true
                  ? Text(
                      'Opened',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    )
                  : Text(
                      'closed',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
              SizedBox(
                height: 10,
              ),
              if (gotStores.data['isStoreOpened'] == true)
                StreamBuilder(
                  stream: customerServices
                      .getStoreBookings(gotStores.reference.path),
                  builder: (context, snapshot2) {
                    QuerySnapshot gotDocs = snapshot2.data;
                    if (snapshot2.hasData) {
                      if (gotDocs.documents.length > 0) {
                        if (gotDocs.documents[0]['isBookingOpened']) {
                          return BookingsAvailableWidget(
                            gotDocs: gotDocs.documents[0],
                            storeDoc: gotStores,
                          );
                        }
                        return BookingsNotStarted();
                      }
                    }
                    return BookingsNotStarted();
                  },
                )
            ],
          ),
        ));
  }
}

class BookingsAvailableWidget extends StatelessWidget {
  const BookingsAvailableWidget({
    Key key,
    @required this.gotDocs,
    @required this.storeDoc,
  }) : super(key: key);

  final DocumentSnapshot gotDocs;
  final DocumentSnapshot storeDoc;

  @override
  Widget build(BuildContext context) {
    int waitingTime = gotDocs.data["waitingTime"] * gotDocs.data["customers"];
    Duration duration = Duration(minutes: waitingTime);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.green),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          gotDocs.data['isBookingOpened'] == true
              ? Text(
                  'Bookings Available',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              : Text(
                  'No Bookings Available',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.white,
          ),
          if (duration.inMinutes > 60)
            Text(
              'Waiting Time - ${duration.inHours} Hours',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          if (duration.inMinutes <= 60)
            Text(
              'Waiting Time - ${duration.inMinutes} Minutes',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          SizedBox(
            height: 5,
          ),
          Text(
            'People In Line - ${gotDocs.data["customers"]} Members',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Avg Time - ${gotDocs.data["waitingTime"]} Minutes',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Max Customers - ${gotDocs.data["maxCustomers"]} Members',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          if (gotDocs.data["customers"] != gotDocs.data["maxCustomers"])
            RaisedButton(
              color: Colors.orange,
              onPressed: () async {
                final bookingDoc = gotDocs.data;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomerVisitForm(
                          bookingDoc: gotDocs,
                          storeDoc: storeDoc,
                        )));
              },
              child: Text(
                'Book This Store',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          if (gotDocs.data["customers"] == gotDocs.data["maxCustomers"])
            RaisedButton(
              color: Colors.orange,
              child: Text(
                'Customers Maxed Out',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Note : ${gotDocs.data["message"]}',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class BookingsNotAvailable extends StatelessWidget {
  const BookingsNotAvailable({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.red),
        child: Text("No Bookings Available",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)));
  }
}

class BookingsNotStarted extends StatelessWidget {
  const BookingsNotStarted({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.orange),
        child: Text("Bookings Not Started Yet",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)));
  }
}
