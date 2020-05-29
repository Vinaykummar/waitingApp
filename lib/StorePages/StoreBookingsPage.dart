import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/AuthProvider.dart';

class StoreBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .document(currentUser.user.userDocumentPath)
            .collection('bookings')
            .where('storeUid', isEqualTo: currentUser.user.uid)
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
                // TODO: Handle this case.
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          subtitle:
                              Text(snapshot.data.documents[index].data['date']),
                          title: Text(
                              ' Bookings Opended : ${snapshot.data.documents[index].data['isBookingOpened']}')),
                    );
                  },
                );
              }
              return Center(
                child: Text("No Bookings available"),
              );

              break;
            case ConnectionState.done:
            // TODO: Handle this case.
              break;
          }
          return Center(
            child: Text("No Bookings available"),
          );
        });
  }
}
