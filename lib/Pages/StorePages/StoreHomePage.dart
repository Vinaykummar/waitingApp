import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Models/BookingModel.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Pages/StorePages/StoreBookingFormPage.dart';
import 'package:stateDemo/Helpers/timeHelpers.dart';

import 'package:stateDemo/Pages/StorePages/BookedCustomersPage.dart';
import 'package:stateDemo/Services/FirebaseAuthService.dart';
import 'package:stateDemo/Services/StoreServices.dart';

class StoreHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    StoreServices storeServices = StoreServices();
    print(TimeHelpers().todaysDate());

    int waitingTime;
    String label;

    return StreamBuilder<List<BookingModel>>(
        stream: storeServices.getTodaysBookingDocument(
            currentUser.user.userDocumentPath,
            currentUser.user.uid,
            TimeHelpers().todaysDate()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              // TODO: Handle this case.
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              List<BookingModel> bookings = snapshot.data;
              if (bookings.length > 0) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Text('Customers In Line : ${bookings[0].customers}'),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Avg Wait Time : ${bookings[0].waitingTime}'),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          print(bookings[0].customers);
                          int present = bookings[0].customers;
                          present += 1;
                          await storeServices.increaseCustomerCount(
                              bookings[0].firebaseDocument.reference.path,
                              {'customers': present});
                        },
                        child: Text(
                          'Increase Customer by +1',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.indigo,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          print(bookings[0].customers);
                          int present = bookings[0].customers;
                          present -= 1;
                          await storeServices.decreaseCustomerCount(
                              bookings[0].firebaseDocument.reference.path,
                              {'customers': present});

                          QuerySnapshot bookedCustomers =
                              await storeServices.getBookedCustomers(
                                  bookings[0].firebaseDocument.reference.path);

                          bookedCustomers.documents
                              .forEach((DocumentSnapshot document) async {
                            int presentTokenNo = document.data['tokenNo'];
                            presentTokenNo -= 1;
                            await storeServices.updateVisitorsTokenNo(
                                document.data['visitDocPath'],
                                {'tokenNo': presentTokenNo});

                            await storeServices.updateBookedCustomersTokenNo(
                                document.reference.path,
                                {'tokenNo': presentTokenNo});
                          });
                        },
                        child: Text(
                          'Decrease Customer by -1',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.indigo,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          initialValue: bookings[0].waitingTime.toString(),
                          decoration:
                              InputDecoration(labelText: 'Average Wait Time'),
                          onChanged: (value) => waitingTime = int.parse(value),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          await storeServices.updateBookingWaitingTime(
                              bookings[0].firebaseDocument.reference.path,
                              {'waitingTime': waitingTime});
                        },
                        child: Text(
                          'Update Waiting Time',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.indigo,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          initialValue: bookings[0].message,
                          decoration: InputDecoration(labelText: 'Message'),
                          onChanged: (value) => label = value,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          await storeServices.updateBookingMessage(
                              bookings[0].firebaseDocument.reference.path,
                              {'message': label});
                        },
                        child: Text(
                          'Update Message',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.indigo,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BookedCustomersPage(
                              bookedDoc: bookings[0].firebaseDocument,
                            ),
                          ));
                        },
                        child: Text(
                          'Customers List',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.indigo,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          await storeServices.closeBooking(
                              bookings[0].firebaseDocument.reference.path,
                              {'isBookingOpened': false});
                        },
                        child: Text(
                          'Close booking',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              }
              return StreamBuilder<DocumentSnapshot>(
                  stream: storeServices
                      .getMystore(currentUser.user.userDocumentPath),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        // TODO: Handle this case.
                        break;
                      case ConnectionState.waiting:
                        // TODO: Handle this case.
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active:
                        // TODO: Handle this case.
                        if (snapshot.data['isStoreOpened'] == true) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("No Bookings available Today"),
                                SizedBox(
                                  height: 10,
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          StoreBookingFormPage(),
                                    ));
                                  },
                                  child: Text('Start Booking'),
                                  color: Colors.indigo,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RaisedButton(
                                  onPressed: () async {
                                    await storeServices.closeStore(
                                        snapshot.data.reference.path,
                                        {'isStoreOpened': false});
                                  },
                                  child: Text('Close Store'),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          );
                        }
                        return RaisedButton(
                          onPressed: () async {
                            await storeServices.openStore(
                                snapshot.data.reference.path,
                                {'isStoreOpened': true});
                          },
                          child: Text('Open Store'),
                          color: Colors.green,
                        );
                        break;
                      case ConnectionState.done:
                        // TODO: Handle this case.
                        break;
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("No Bookings available Today"),
                        ],
                      ),
                    );
                  });

              break;
            case ConnectionState.done:
              // TODO: Handle this case.

              break;
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("No Bookings available Today"),
              ],
            ),
          );
        });
  }
}
