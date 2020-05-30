import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookedCustomersPage extends StatelessWidget {
  final DocumentSnapshot bookedDoc;

  BookedCustomersPage({@required this.bookedDoc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booked Customers List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .document(bookedDoc.reference.path)
            .collection('customers')
            .orderBy('tokenNo', descending: false)
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
              if (snapshot2.data.documents.length > 0) {
                return ListView.builder(
                  itemCount: snapshot2.data.documents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if(snapshot2.data.documents[index].data['status'] == 'OnGoing')
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                                snapshot2.data.documents[index].data['status'],style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                          ),
                          if(snapshot2.data.documents[index].data['status'] == 'Completed')
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                snapshot2.data.documents[index].data['status'],style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),),
                            ),
                          ListTile(
                              trailing: snapshot2.data.documents[index].data['status'] == 'OnGoing' ? IconButton(
                                  icon: Icon(Icons.check,color: Colors.indigo,),
                                  onPressed: () async {
                                    await Firestore.instance
                                        .document(snapshot2.data.documents[index]
                                            .data['visitDocPath'])
                                        .setData({'status': "Completed"}, merge: true);
                                    await Firestore.instance
                                        .document(snapshot2.data.documents[index].reference.path
                                        )
                                        .setData({'status': "Completed"}, merge: true);
                                  }) : SizedBox.shrink(),
                              subtitle: Text(
                                  snapshot2.data.documents[index].data['email']),
                              title: Text(
                                  '${snapshot2.data.documents[index].data['name']} / Token No : ${snapshot2.data.documents[index].data['tokenNo']}')),
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
