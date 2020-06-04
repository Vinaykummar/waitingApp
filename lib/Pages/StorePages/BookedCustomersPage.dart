import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stateDemo/Models/BookedCustomerModel.dart';
import 'package:stateDemo/Services/StoreServices.dart';

class BookedCustomersPage extends StatelessWidget {
  final DocumentSnapshot bookedDoc;
  StoreServices storeServices = StoreServices();

  BookedCustomersPage({@required this.bookedDoc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Booked Customers List", style: TextStyle(color: Colors.black),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: storeServices.getAllBookedCustomers(bookedDoc.reference.path),
        builder: (context, snapshot2) {
          switch (snapshot2.connectionState) {
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
              print(bookedDoc.reference.path);
              print(snapshot2.hasData);
              if (snapshot2.hasData) {
                return ListView.builder(
                  itemCount: snapshot2.data.documents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (snapshot2.data.documents[index]['status'] == 'OnGoing')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                snapshot2.data.documents[index]['status'],
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (snapshot2.data.documents[index]['status'] == 'Completed')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                snapshot2.data.documents[index]['status'],
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ListTile(
                              trailing:
                                  snapshot2.data.documents[index]['status'] == 'OnGoing'
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.indigo,
                                          ),
                                          onPressed: () async {
                                            await storeServices
                                                .updateVisitorsStatus(
                                                    snapshot2.data.documents[index]
                                                        ['visitDocPath'],
                                                    {'status': "Completed"});

                                            await storeServices
                                                .updateBookedCustomersStatus(
                                                    snapshot2.data.documents[index]
                                                        .reference
                                                        .path,
                                                    {'status': "Completed"});
                                          })
                                      : SizedBox.shrink(),
                              subtitle: Text(snapshot2.data.documents[index]['email']),
                              title: Text(
                                  '${snapshot2.data.documents[index]['name']} / Token No : ${snapshot2.data.documents[index]['tokenNo']}')),
                        ],
                      ),
                    );
                  },
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("No Customers Booked Yet"),
                  ],
                ),
              );

              break;
            case ConnectionState.done:
              // TODO: Handle this case.
              break;
          }
          return Center(
            child: Text("No Customers Booked Yet"),
          );
        },
      ),
    );
  }
}
