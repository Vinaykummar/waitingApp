import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stateDemo/Services/CustomerServices.dart';


class CustomerStoreSearchPage extends StatelessWidget {
  String storeName;
  CustomerServices customerServices = CustomerServices();


  Stream<QuerySnapshot> findStores(String query){
    return customerServices.findStores(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('search'),),
      body: Column(
        children: <Widget>[
          TextFormField(
            onChanged: (value)  {
               findStores(value);
            },

            decoration: InputDecoration(labelText: 'Guests Count'),
          ),
        ],
      ),
    );
  }
}
