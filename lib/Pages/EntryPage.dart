import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Pages/Homepage.dart';
import 'package:stateDemo/Pages/LandingPage.dart';
import 'package:stateDemo/Pages/ProfilePage.dart';
import 'package:stateDemo/Models/User.dart';


class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  SharedPreferences sharedPreferences;
    final currentUser = CurrentUserProvider();


  String userFromPref;
  User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return FutureBuilder(
      future: auth.currentUser(),
      initialData: userFromPref,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
       

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            // TODO: Handle this case.
            break;
          case ConnectionState.waiting:
            // TODO: Handle this case.
            return Scaffold(
              body: Center(child: Text("waiting")),
            );

            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            // TODO: Handle this case.
            // if (snapshot.hasData) {
            //   final decoded = json.decode(snapshot.data);
            //   currentUser.updateCurrentUser(User.fromMap(decoded));
            //   return HomePage();
            // } else {
            //   return LandingPage();
            // }

            print(userFromPref);
            if (snapshot.hasData) {
              print('letd go');
              return HomePage();
            } else {
              print('no not going');
              return LandingPage();
            }

            break;
        }
      },
    );
  }
}
