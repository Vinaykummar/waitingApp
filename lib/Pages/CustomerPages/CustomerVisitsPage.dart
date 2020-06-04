import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Models/VisitModel.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Services/CustomerServices.dart';
import 'package:stateDemo/fakedata/fakedata.dart';

class CustomerVisitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    FakeData faker = FakeData();
    CustomerServices customerServices = CustomerServices();

    return StreamBuilder<List<VisitModel>>(
        stream: customerServices.getMyVisits(currentUser.user.userDocumentPath),
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
              print(snapshot.data.length);
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    VisitModel visitModel = snapshot.data[index];
                    return Card(
                        color: visitModel.status == 'Completed'
                            ? Colors.red
                            : Colors.green,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                visitModel.store["name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                visitModel.store['address'],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Token No : ${visitModel.tokenNo}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Visit Status : ${visitModel.status}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
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
                child: Text("You have no visits yet"),
              );

              break;
            case ConnectionState.done:
              // TODO: Handle this case.

              break;
          }
          return Center(
            child: Text("You have no visits yet"),
          );
        });
  }
}
