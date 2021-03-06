import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Models/BookingModel.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Services/StoreServices.dart';

class StoreBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    StoreServices storeServices = StoreServices();


    return StreamBuilder<List<BookingModel>>(
        stream: storeServices.getAllBookings(currentUser.user.userDocumentPath, currentUser.user.uid),
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
              print(bookings.length);
              if (bookings.length > 0) {
                // TODO: Handle this case.
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          subtitle: Text(bookings[index].date),
                          title: Text(
                              ' Bookings Opended : ${bookings[index].isBookingOpened}')),
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
