import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/AuthProvider.dart';

class StoreHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .document(currentUser.user.userDocumentPath)
            .collection('bookings')
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
              if (snapshot.hasData) {
                return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .document(snapshot.data.documents[0].reference.path)
                      .collection('customers')
                      .snapshots(),
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
                        return ListView.builder(
                          itemCount: snapshot2.data.documents.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                subtitle: Text(snapshot2
                                      .data.documents[0].data['address']),
                                  title: Text(snapshot2
                                      .data.documents[0].data['name'])),
                            );
                          },
                        );
                        break;
                      case ConnectionState.done:
                        // TODO: Handle this case.
                        break;
                    }
                  },
                );
              }

              return Center(
                child: Text("No Customers available"),
              );

              break;
            case ConnectionState.done:
              // TODO: Handle this case.

              break;
          }
        });
  }
}
