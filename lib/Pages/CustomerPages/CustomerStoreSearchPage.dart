import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CustomerStoreSearchPage extends StatelessWidget {
  String storeName;

  Stream<QuerySnapshot> findStores(String query){
    return Firestore.instance.collection('customers').where('role', isEqualTo: 'store').where('keywords',arrayContains:query).snapshots();
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
