import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Pages/Homepage.dart';
import 'package:stateDemo/Pages/EntryPage.dart';
import 'package:stateDemo/Models/User.dart';
import 'package:stateDemo/fakedata/fakedata.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    final auth = FirebaseAuth.instance;
    final firestore = Firestore.instance;
    SharedPreferences sharedPreferences;
  

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  await auth.signOut();
                  sharedPreferences = await SharedPreferences.getInstance();
                  await sharedPreferences.clear();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => EntryPage()));
                })
          ],
        ),
        body: FutureBuilder(
          future: SharedPreferences.getInstance(),
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
                break;
              case ConnectionState.done:
                // TODO: Handle this case.
                try {
               
                  return Column(
                    children: [
                     Text(currentUser.user.email),
                    ],
                  );
                } catch (e) {
                  return Center(
                    child: Text(e.toString()),
                  );
                }
                break;
            }
          },
        ));
  }
}
