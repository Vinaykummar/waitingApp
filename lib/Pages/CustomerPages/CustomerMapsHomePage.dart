//import 'dart:typed_data';
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:stateDemo/Helpers/Marker.dart';
//import 'package:stateDemo/Services/CustomerServices.dart';
//
//class CustomerMapsHomePage extends StatefulWidget {
//  final QuerySnapshot stores;
//
//  CustomerMapsHomePage({@required this.stores});
//
//  @override
//  _CustomerMapsHomePageState createState() => _CustomerMapsHomePageState();
//}
//
//class _CustomerMapsHomePageState extends State<CustomerMapsHomePage> {
//  GoogleMapController _controller;
//  List<Marker> markers = [];
//  Geolocator _geolocator = Geolocator();
//  Position position;
//
//  CameraPosition myLocation = CameraPosition(
//    target: LatLng(17.370079, 78.423320),
//    zoom: 14,
//  );
//
//  Set<Marker> myMarkers = <Marker>[].toSet();
//
//  @override
//  void initState() {
//    super.initState();
//   callMarkerGen();
//  }
//
//  callMarkerGen() {
//    MarkerGenerator(markerWidgets(), (bitmaps) {
//      setState(() {
//        markers = mapBitmapsToMarkers(bitmaps);
//      });
//    }).generate(context);
//  }
//
//  List<Widget> markerWidgets() {
//    return widget.stores.documents
//        .map((DocumentSnapshot documentSnapshot) => _getMarkerWidget(
//            documentSnapshot.data['name'],
//            documentSnapshot.data['isStoreOpened'],
//            documentSnapshot))
//        .toList();
//  }
//
//  List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
//
//    List<Marker> markersList = [];
//    bitmaps.asMap().forEach((i, bmp) {
//      final city = cities[i];
//      markersList.add(Marker(
//          markerId: MarkerId(city.name),
//          position: city.position,
//          icon: BitmapDescriptor.fromBytes(bmp)));
//    });
//    return markersList;
//  }
//
//// Example of marker widget
//  Widget _getMarkerWidget(
//      String name, bool isStoreOpened, DocumentSnapshot documentSnapshot) {
//    print(documentSnapshot.reference.path);
//    return Container(
//      padding: EdgeInsets.all(5),
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(8),
//        color: Colors.green,
//      ),
//      child: Container(
//        child: Text(
//          name,
//          maxLines: 1,
//          overflow: TextOverflow.ellipsis,
//          style: TextStyle(
//              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
//        ),
//      ),
//    );
//  }
//
//// Example of backing data
//  List<City> cities = [];
//
//  CustomerServices customerServices = CustomerServices();
//
//  @override
//  Widget build(BuildContext context) {
//    _geolocator.checkGeolocationPermissionStatus(
//        locationPermission: GeolocationPermission.locationAlways);
//
//   return  StreamBuilder<QuerySnapshot>(
//        stream: customerServices.getNearbyStores(),
//        builder: (context, snapshot) {
//          switch (snapshot.connectionState) {
//            case ConnectionState.none:
//              // TODO: Handle this case.
//              break;
//            case ConnectionState.waiting:
//              // TODO: Handle this case.
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//              break;
//            case ConnectionState.active:
//              // TODO: Handle this case.
//              print(snapshot.data.documents.length);
//
//              if (snapshot.data.documents.length > 0) {
//                widget.stores.documents
//                    .map((DocumentSnapshot documentSnapshot) => cities.add(City(
//                    documentSnapshot.data['name'],
//                    LatLng(documentSnapshot.data['geoPoint']['latitude'],
//                        documentSnapshot.data['geoPoint']['longitude']))))
//                    .toList();
//                return Stack(
//                  children: [
//                    GoogleMap(
//                        onMapCreated: (mapController) async {
//                          position = await _geolocator.getCurrentPosition(
//                              desiredAccuracy: LocationAccuracy.best,
//                              locationPermissionLevel:
//                                  GeolocationPermission.location);
//                          _controller = mapController;
//                          _controller.animateCamera(
//                              CameraUpdate.newCameraPosition(CameraPosition(
//                            target:
//                                LatLng(position.latitude, position.longitude),
//                            zoom: 16,
//                          )));
//                        },
//                        myLocationEnabled: true,
//                        mapType: MapType.normal,
//                        markers: markers.toSet(),
//                        initialCameraPosition: myLocation),
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        Container(
//                          height: 140,
//                          width: double.infinity,
//                          color: Colors.white,
//                        )
//                      ],
//                    )
//                  ],
//                );
//              }
//              return Center(
//                child: Text("Sorry no stores available"),
//              );
//
//              break;
//            case ConnectionState.done:
//              // TODO: Handle this case.
//
//              break;
//          }
//          return Center(
//            child: Text("Sorry no stores available"),
//          );
//        });
//  }
//}
//
//class City {
//  final String name;
//  final LatLng position;
//
//  City(this.name, this.position);
//}
