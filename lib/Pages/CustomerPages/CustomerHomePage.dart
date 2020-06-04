import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorated_google_maps_flutter/decorated_google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Pages/CustomerPages/CustomerOnGoingVisitPage.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Services/CustomerServices.dart';

import 'CustomerStoreDetailsPage.dart';

class CustomerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    CustomerServices customerServices = CustomerServices();
    String date() {
      return '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    }

    return StreamBuilder<QuerySnapshot>(
      stream: customerServices
          .getCustomerVisitDocument(currentUser.user.userDocumentPath),
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
        return Center(
          child: Text('No visit Doc'),
        );
      },
    );
  }
}

class StoresBuilder extends StatelessWidget {
  CustomerServices customerServices = CustomerServices();

  StreamController mapStream;

  GoogleMapController _googleMapController;

  List<Locationed> markers = <Locationed>[];

  Geolocator _geolocator = Geolocator();
  String text;
  Position position;

 
  loadMarkers(QuerySnapshot snapshot, BuildContext context){
    snapshot.documents
        .map((DocumentSnapshot storeDoc) => markers.add(Locationed(
        target: LatLng(storeDoc.data['geoPoint']['latitude'],
            storeDoc.data['geoPoint']['longitude']),
        height: 50,
        width: 120,
        child: InkWell(
          onTap: () {
            if (storeDoc.data['isStoreOpened']) {
              showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      CustomerStoreDetailsPage(
                        storeDoc: storeDoc,
                      ));
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10)),
            child: StreamBuilder<QuerySnapshot>(
              stream: customerServices
                  .getStoreBookings(storeDoc.reference.path),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  // TODO: Handle this case.
                    break;
                  case ConnectionState.waiting:
                  // TODO: Handle this case.
                    return SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.active:
                  // TODO: Handle this case.
                    if (snapshot.data.documents.length > 0) {
                      int customers = snapshot
                          .data.documents[0].data['customers'];
                      int avgTime = snapshot.data.documents[0]
                          .data['waitingTime'];
                      int waitingTime = customers * avgTime;

                      return MarkerWithTime(
                          storeDoc: storeDoc,
                          waitingTime: waitingTime);
                    }

                    return MarkerWithNoTime(
                      storeDoc: storeDoc,
                    );
                    break;
                  case ConnectionState.done:
                  // TODO: Handle this case.
                    break;
                }
                return MarkerWithNoTime(
                  storeDoc: storeDoc,
                );
              },
            ),
          ),
        ))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);

     CameraPosition myLocation = CameraPosition(
    target: LatLng(currentUser.user.geoPoint.latitude, currentUser.user.geoPoint.longitude),
    zoom: 14,
  );


    return StreamBuilder<QuerySnapshot>(
        stream: customerServices.getNearbyStores(),
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
                loadMarkers(snapshot.data, context);
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: DecoratedGoogleMap(
                          children: markers,
                          onMapCreated: (mapController) async {
                            position = await _geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.best,
                                locationPermissionLevel:
                                    GeolocationPermission.location);
                            _googleMapController = mapController;

                            _googleMapController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                              target:
                                  LatLng(position.latitude, position.longitude),
                              zoom: 16,
                            )));
                          },
                          onCameraMove: (position) {
                            print(position);
                          },
                          myLocationEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: myLocation),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      onChanged: (value) => text = value,
                                      decoration: InputDecoration(
                                          hintText: 'Search Location',
                                          filled: true,
                                          enabledBorder: InputBorder.none,
                                          fillColor:
                                              Colors.black.withOpacity(0.1)),
                                    ),
                                  )),
                              Expanded(
                                child: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {
                                      List<Placemark> placemarkers =
                                          await _geolocator
                                              .placemarkFromAddress(text);
                                      position = placemarkers[0].position;
                                      print(placemarkers[0].position);
                                      _googleMapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: LatLng(
                                                      position.latitude,
                                                      position.longitude),
                                                  zoom: 15)));
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
          return Center(child: Text("Sorry no stores available"));
        });
  }
}

class MarkerWithNoTime extends StatelessWidget {
  final DocumentSnapshot storeDoc;

  const MarkerWithNoTime({Key key, @required this.storeDoc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                storeDoc.data['name'],
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              storeDoc.data['isStoreOpened'] == true
                  ? Text(
                      'Opened',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    )
                  : Text(
                      'Closed',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class MarkerWithTime extends StatelessWidget {
  final DocumentSnapshot storeDoc;
  final int waitingTime;

  MarkerWithTime({Key key, @required this.waitingTime, @required this.storeDoc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(minutes: waitingTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        storeDoc.data['isStoreOpened'] == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (duration.inMinutes > 60)
                    Text(
                      "${duration.inHours}",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  if (duration.inMinutes > 60)
                    Text(
                      'Hrs',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  if (duration.inMinutes <= 60)
                    Text(
                      "${duration.inMinutes}",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  if (duration.inMinutes <= 60)
                    Text(
                      'Min',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                ],
              )
            : SizedBox.shrink(),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                storeDoc.data['name'],
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              SizedBox(height: 5,),
              storeDoc.data['isStoreOpened'] == true
                  ? Text(
                      'Opened',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    )
                  : Text(
                      'Closed',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
