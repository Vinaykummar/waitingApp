import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/AuthProvider.dart';
import 'package:stateDemo/fakedata/fakedata.dart';

class StoreBookingFormPage extends StatefulWidget {
  @override
  _StoreBookingFormPageState createState() => _StoreBookingFormPageState();
}

class _StoreBookingFormPageState extends State<StoreBookingFormPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context);
    final _formKey = GlobalKey<FormState>();
    FakeData fakeData = FakeData();
    String _customers;
    String _avgTime;
    String _maxCustomers;

    createBooking(Map<String, dynamic> formData) async {
      await Firestore.instance
          .document(currentUser.user.userDocumentPath)
          .collection('bookings')
          .add(fakeData.genBooking( formData, currentUser.user.uid));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Booking Form"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Customers On Line'),
                    onSaved: (value) => _customers = value,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Avg Waiting Time'),
                    onSaved: (value) => _avgTime = value,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Max Number Of Patients'),
                    onSaved: (value) => _maxCustomers = value,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _formKey.currentState.validate();
                      _formKey.currentState.save();

                      Map<String, dynamic> formData = {
                        'inLineCustomers': int.parse(_customers),
                        'avgTime': int.parse(_avgTime),
                        'maxCustomers': int.parse(_maxCustomers)
                      };

                      createBooking(formData);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.indigo,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
