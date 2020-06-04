import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Models/User.dart';
import 'package:stateDemo/Pages/Homepage.dart';
import 'package:stateDemo/Pages/LoginPage.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Services/CustomerServices.dart';
import 'package:stateDemo/Services/FirebaseAuthService.dart';

import 'SignUpPage.dart';
import 'StorePages/StoreSignUpPage.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);
    CustomerServices customerServices = CustomerServices();
    FirebaseAuthService firebaseAuthService = FirebaseAuthService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("LandingPage", style: TextStyle(color: Colors.black),),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () async {

                DocumentSnapshot endUserResult;
                final AuthResult authResult = await firebaseAuthService
                    .signInWithEmailAndPassword('customer@test.com', '123456');
                final String uid = authResult.user.uid;
                final userDetails = await customerServices.getCustomer(uid);
                final list = userDetails.documents
                    .where((element) => element.data['uid'] == uid)
                    .first;
                currentUser.updateCurrentUser(User(
                    email: list.data['email'],
                    name: list.data['name'],
                    role: list.data['role'],
                    uid: list.data['uid'],
                    userDocumentId: list.documentID,
                    userDocumentPath: list.reference.path));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('Demo Customer'),
            ),
            RaisedButton(
              onPressed: () async {
                DocumentSnapshot endUserResult;
                final AuthResult authResult = await firebaseAuthService
                    .signInWithEmailAndPassword('store@test.com', '123456');
                final String uid = authResult.user.uid;
                final userDetails = await customerServices.getCustomer(uid);
                final list = userDetails.documents
                    .where((element) => element.data['uid'] == uid)
                    .first;
                currentUser.updateCurrentUser(User(
                    email: list.data['email'],
                    name: list.data['name'],
                    role: list.data['role'],
                    uid: list.data['uid'],
                    userDocumentId: list.documentID,
                    userDocumentPath: list.reference.path));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('Demo Store'),
            ),

            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Login'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage(userType: 'customer',)));
              },
              child: Text('Signup'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage(userType: 'store',)));
              },
              child: Text('Enroll as Store'),
            ),
          ],
        ),
      ),
    );
  }
}
