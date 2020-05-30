import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Pages/CustomerPages/CustomerOnGoingVisitPage.dart';
import 'package:stateDemo/Pages/CustomerPages/CustomerVisitForm.dart';
import 'package:stateDemo/fakedata/fakedata.dart';

class CustomerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    FakeData faker = FakeData();

    void uploadStore() async {
      await Firestore.instance.collection('customers').add(faker.genStore());
    }

    String date() {
      return '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    }

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .document(currentUser.user.userDocumentPath)
          .collection('visits')
          .where('status', isEqualTo: 'OnGoing')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
            bool visiting = true;
            QuerySnapshot gotDocs = snapshot.data;
            print(gotDocs.documents.length);

            if (gotDocs.documents.length > 0) {
              return CustomerOnGoingVisitPage(visitedDoc: gotDocs.documents[0]);
            }
            return StoresBuilder();
            break;
          case ConnectionState.done:
            // TODO: Handle this case.
            break;
        }
      },
    );
  }
}

class StoresBuilder extends StatelessWidget {
  const StoresBuilder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('customers')
            .where('role', isEqualTo: 'store')
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
                    final gotStores = snapshot.data;
                    return InkWell(
                      onTap: () {
                        print(gotStores.documents[index].data);
                      },
                      child: StoreWidget(
                        gotStores: gotStores,
                        index: index,
                      ),
                    );
                  },
                );
              }
              return Center(
                child: Text("Sorry no stores available"),
              );

              break;
            case ConnectionState.done:
              // TODO: Handle this case.

              break;
          }
        });
  }
}

class StoreWidget extends StatelessWidget {
  const StoreWidget({Key key, @required this.gotStores, @required this.index})
      : super(key: key);

  final QuerySnapshot gotStores;
  final int index;

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
                gotStores.documents[index]['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                gotStores.documents[index]['address'],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 5,
              ),
              gotStores.documents[index]['isStoreOpened'] == true
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
              if (gotStores.documents[index].data['isStoreOpened'] == true)
                StreamBuilder(
                  stream: Firestore.instance
                      .document(gotStores.documents[index].reference.path)
                      .collection('bookings')
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot2) {
                    QuerySnapshot gotDocs = snapshot2.data;
                    if (snapshot2.hasData) {
                      if (gotDocs.documents.length > 0) {
                        if (gotDocs.documents[0]['isBookingOpened']) {
                          return BookingsAvailableWidget(
                            gotDocs: gotDocs,
                            storeDoc: gotStores.documents[index],
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

class BookingsAvailableWidget extends StatelessWidget {
  const BookingsAvailableWidget({
    Key key,
    @required this.gotDocs,
    @required this.storeDoc,
  }) : super(key: key);

  final QuerySnapshot gotDocs;
  final DocumentSnapshot storeDoc;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    final fakeData = FakeData();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.green),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          gotDocs.documents[0]['isBookingOpened'] == true
              ? Text(
                  'Bookings Available',
                  style: TextStyle(
                      fontSize: 14,
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
          Text(
            'Waiting Time - ${gotDocs.documents[0]["waitingTime"] * gotDocs.documents[0]["customers"]} Minutes',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'People In Line - ${gotDocs.documents[0]["customers"]} Members',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Avg Time - ${gotDocs.documents[0]["waitingTime"]} Minutes',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          RaisedButton(
            color: Colors.orange,
            onPressed: () async {
              final bookingDoc = gotDocs.documents[0];
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CustomerVisitForm(
                        bookingDoc: bookingDoc,
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
          SizedBox(
            height: 5,
          ),
          Text(
            'Note : ${gotDocs.documents[0]["message"]}',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
