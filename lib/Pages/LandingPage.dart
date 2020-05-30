import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Pages/Homepage.dart';
import 'package:stateDemo/Pages/ProfilePage.dart';
import 'package:stateDemo/Models/User.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestore = Firestore.instance;
    final auth = FirebaseAuth.instance;
    final currentUser = Provider.of<CurrentUserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("LandingPage"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                DocumentSnapshot endUserResult;
                final AuthResult authResult =
                    await auth.signInWithEmailAndPassword(
                        email: 'customer@test.com', password: '123456');
                final String uid = authResult.user.uid;
                final userDetails = await firestore
                    .collection('customers')
                    .where('uid', isEqualTo: uid)
                    .getDocuments();
                final list = userDetails.documents
                    .where((element) => element.data['uid'] == uid)
                    .first;
                 currentUser.updateCurrentUser(User(
                   email: list.data['email'],
                   name: list.data['name'],
                   role: list.data['role'],
                   uid: list.data['uid'],
                   userDocumentId: list.documentID,
                   userDocumentPath: list.reference.path
                   ));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('SignIn as Customer'),
            ),
            RaisedButton(
              onPressed: () async {
                DocumentSnapshot endUserResult;
                final AuthResult authResult =
                    await auth.signInWithEmailAndPassword(
                        email: 'store@test.com', password: '123456');
                final String uid = authResult.user.uid;
                final userDetails = await firestore
                    .collection('customers')
                    .where('uid', isEqualTo: uid)
                    .getDocuments();
                final list = userDetails.documents
                    .where((element) => element.data['uid'] == uid)
                    .first;
                 currentUser.updateCurrentUser(User(
                   email: list.data['email'],
                   name: list.data['name'],
                   role: list.data['role'],
                   uid: list.data['uid'],
                   userDocumentId: list.documentID,
                   userDocumentPath: list.reference.path
                   ));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('SignIn as Store'),
            ),
          ],
        ),
      ),
    );
  }
}
