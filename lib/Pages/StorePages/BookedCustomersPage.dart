import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stateDemo/Models/BookedCustomerModel.dart';

class BookedCustomersPage extends StatelessWidget {
  final DocumentSnapshot bookedDoc;

  BookedCustomersPage({@required this.bookedDoc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booked Customers List"),
      ),
      body: StreamBuilder<List<BookedCustomerModel>>(
        stream: Firestore.instance
            .document(bookedDoc.reference.path)
            .collection('customers')
            .orderBy('tokenNo', descending: false)
            .snapshots()
            .map((QuerySnapshot bookedCustomersDocs) => bookedCustomersDocs
                .documents
                .map((DocumentSnapshot bookedCustomersDoc) =>
                    BookedCustomerModel.fromMap(
                        bookedCustomersDoc.data, bookedCustomersDoc))
                .toList()),
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
              List<BookedCustomerModel> bookedCustomers = snapshot2.data;
              if (bookedCustomers.length > 0) {
                return ListView.builder(
                  itemCount: bookedCustomers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (bookedCustomers[index].status == 'OnGoing')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                bookedCustomers[index].status,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (bookedCustomers[index].status == 'Completed')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                bookedCustomers[index].status,
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ListTile(
                              trailing: bookedCustomers[index].status ==
                                      'OnGoing'
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.check,
                                        color: Colors.indigo,
                                      ),
                                      onPressed: () async {
                                        await Firestore.instance
                                            .document(bookedCustomers[index]
                                                .visitDocPath)
                                            .setData({'status': "Completed"},
                                                merge: true);
                                        await Firestore.instance
                                            .document(bookedCustomers[index]
                                                .firebaseDocument
                                                .reference
                                                .path)
                                            .setData({'status': "Completed"},
                                                merge: true);
                                      })
                                  : SizedBox.shrink(),
                              subtitle: Text(bookedCustomers[index].email),
                              title: Text(
                                  '${bookedCustomers[index].name} / Token No : ${bookedCustomers[index].tokenNo}')),
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
