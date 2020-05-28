import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/AuthProvider.dart';
import 'package:stateDemo/fakedata/fakedata.dart';

class CustomerVisitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context);
    FakeData faker = FakeData();

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .document(currentUser.user.userDocumentPath)
            .collection('visits').orderBy('date', descending: true)
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
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    
                    return Card(
                      color: snapshot.data.documents[index]["status"] == 'Completed' ? Colors.red : Colors.green,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data.documents[index]["store"]["name"],
                                style: TextStyle(color: Colors.white,
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data.documents[index]["store"]
                                    ['address'],
                                style: TextStyle(
                                    fontSize: 14,color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Token No : ${snapshot.data.documents[index]["tokenNo"]}',
                                style: TextStyle(
                                  fontSize: 14,color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                               SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Visit Status : ${snapshot.data.documents[index]["status"]}',
                                style: TextStyle(
                                  fontSize: 14,color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                );
              }
              return Center(
                child: Text("No Visits available"),
              );

              break;
            case ConnectionState.done:
              // TODO: Handle this case.

              break;
          }
        });
  }
}
