import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorated_google_maps_flutter/decorated_google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Models/User.dart';
import 'package:stateDemo/Services/FirebaseAuthService.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';

import '../Homepage.dart';


class CustomerSignUpFormPage extends StatefulWidget {
  final String uuid;
  final DocumentReference createdDocument;

  const CustomerSignUpFormPage(
      {Key key, @required this.uuid, @required this.createdDocument})
      : super(key: key);

  @override
  _CustomerSignUpFormPageState createState() => _CustomerSignUpFormPageState();
}

class _CustomerSignUpFormPageState extends State<CustomerSignUpFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _mobile;
  String _email;
  String _address;

  bool isFormSubmitted = false;
  GoogleMapController _googleMapController;
  Geolocator _geolocator = Geolocator();
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  Position position;
  LatLng userLatLng;
  CameraPosition myLocation = CameraPosition(
    target: LatLng(17.370079, 78.423320),
    zoom: 14,
  );
 
  final Set<Marker> _markers = {};
  TextEditingController _addressController = TextEditingController();



  geocodeFromPointToAddress(LatLng latLng) async {
    List<Placemark> address = await _geolocator.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude);
    Placemark locationAddress = address[0];
    setState(() {
      userLatLng = latLng;
      _addressController.text =
          '${locationAddress.name},${locationAddress.subLocality},${locationAddress.locality},${locationAddress.country}';
    });
  }

  geocodeFromAddressToPoint(String searchAddress) async {
    List<Placemark> address =
        await _geolocator.placemarkFromAddress(searchAddress);
    Placemark locationPoint = address[0];
    print(locationPoint.position);
    updateMarker(LatLng(
        locationPoint.position.latitude, locationPoint.position.longitude));
    animateToLocation(locationPoint.position);
  }

  updateMarker(LatLng latLng) {
    setState(() {
      userLatLng = latLng;
      _markers.add(Marker(
        markerId: MarkerId('value'),
        position: latLng,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    geocodeFromPointToAddress(latLng);
  }

  animateToLocation(Position position) async {
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            zoom: 19,
            target: LatLng(
              position.latitude,
              position.longitude,
            ))));
    geocodeFromPointToAddress(LatLng(position.latitude, position.longitude));
    updateMarker(LatLng(position.latitude, position.longitude));
  }

  String validateMobile(String value) {
    if (value.isEmpty) {
      return 'MobileNumber Cant be empty';
    } else {
      if (value.length < 6) return 'MobileNumber  must contain 10 numbers';
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);

    createCustomer() async {
      if (_formKey.currentState.validate()) {
        try {
          User user = User(
              geoPoint: GeoPoint(userLatLng.latitude, userLatLng.longitude),
              userDocumentPath: widget.createdDocument.path,
              userDocumentId: widget.createdDocument.documentID,
              name: _name,
              uid: widget.uuid,
              signUpDone: true,
              email: _email,
              role: 'customer');
          await Firestore.instance.document(widget.createdDocument.path).setData(user.toJson(),merge: true);
          currentUser.updateCurrentUser(user);
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        } catch (e) {
          print(e);
        }
      }
    }

    print(widget.uuid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Sign Up Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (name) => _name = name,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name Cant be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: (email) => _email = email,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email Cant be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      onChanged: (mobile) => _mobile = mobile,
                      decoration: InputDecoration(
                        hintText: 'Mobile',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Mobile Cant be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Address',
                          suffixIcon: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                _addressController.clear();
                              })),
                      controller: _addressController,
                      onEditingComplete: () =>
                          geocodeFromAddressToPoint(_address),
                      onChanged: (address) => _address = address,
                      validator:  validateMobile,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: DecoratedGoogleMap(
                          onTap: updateMarker,
                          onCameraMove: (position) => print(position),
                          onMapCreated: (controller) async {
                            _googleMapController = controller;
                            position = await _geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high);
                            animateToLocation(position);
                          },
                          markers: _markers,
                          myLocationEnabled: true,
                          initialCameraPosition: myLocation),
                    ),
                    RaisedButton(
                      onPressed:
                          isFormSubmitted == true ? null : createCustomer,
                      child: Text('Submit'),
                    ),
                    if (isFormSubmitted) CircularProgressIndicator(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
