import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/AuthProvider.dart';
import 'package:stateDemo/StorePages/StoreBookingFormPage.dart';
import 'package:stateDemo/classes/timeHelpers.dart';

import 'BookedCustomersPage.dart';

class StoreHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context);
    print(TimeHelpers().todaysDate());
    int waitingTime;
    String label;

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .document(currentUser.user.userDocumentPath)
            .collection('bookings')
            .where('date', isEqualTo: TimeHelpers().todaysDate())
            .where('isBookingOpened', isEqualTo: true)
            .snapshots(),
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
              print(snapshot.data.documents.length);
              if (snapshot.data.documents.length > 0) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Text(
                          'Customers In Line : ${snapshot.data.documents[0].data['customers']}'),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          'Avg Wait Time : ${snapshot.data.documents[0].data['waitingTime']}'),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          print(snapshot.data.documents[0].data['customers']);
                          int present =
                              snapshot.data.documents[0].data['customers'];
                          present += 1;
                          await Firestore.instance
                              .document(
                                  snapshot.data.documents[0].reference.path)
                              .setData({'customers': present}, merge: true);
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
                          print(snapshot.data.documents[0].data['customers']);
                          int present =
                              snapshot.data.documents[0].data['customers'];
                          present -= 1;
                          await Firestore.instance
                              .document(
                                  snapshot.data.documents[0].reference.path)
                              .setData({'customers': present}, merge: true);
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
                          initialValue: snapshot
                              .data.documents[0].data['waitingTime']
                              .toString(),
                          decoration: InputDecoration(
                              labelText: 'Max Number Of Patients'),
                          onChanged: (value) => waitingTime = int.parse(value),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          await Firestore.instance
                              .document(
                                  snapshot.data.documents[0].reference.path)
                              .setData({'waitingTime': waitingTime},
                                  merge: true);
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
                          initialValue:
                              snapshot.data.documents[0].data['message'],
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
                          await Firestore.instance
                              .document(
                                  snapshot.data.documents[0].reference.path)
                              .setData({'message': label}, merge: true);
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
                              bookedDoc: snapshot.data.documents[0],
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
                          await Firestore.instance
                              .document(
                                  snapshot.data.documents[0].reference.path)
                              .delete();
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StoreBookingFormPage(),
                        ));
                      },
                      child: Text(
                        'Start Booking',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.indigo,
                    )
                  ],
                ),
              );
              break;
            case ConnectionState.done:
              // TODO: Handle this case.

              break;
          }
          return Center(
            child: Column(
              children: <Widget>[
                Text("No Bookings available Today"),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text('Start Booking'),
                  color: Colors.indigo,
                )
              ],
            ),
          );
        });
  }
}
