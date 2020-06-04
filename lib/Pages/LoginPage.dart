import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateDemo/Models/User.dart';
import 'package:stateDemo/Pages/CustomerPages/CustomerSignUpFormPage.dart';
import 'package:stateDemo/Providers/AuthProvider.dart';
import 'package:stateDemo/Services/CustomerServices.dart';
import 'package:stateDemo/Services/FirebaseAuthService.dart';
import 'package:stateDemo/Pages/StorePages/StoreSignUpFormPage.dart';
import 'Homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool isFormSubmitted = false;
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  CustomerServices customerServices = CustomerServices();

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUserProvider>(context);

    login() async {
      if (_formKey.currentState.validate()) {
        try {
          setState(() {
            isFormSubmitted = true;
          });
          AuthResult authResult = await _firebaseAuthService
              .signInWithEmailAndPassword(_email, _password);
          final uid = authResult.user.uid;
          final userDetails =
              await customerServices.getCustomer(authResult.user.uid);

          final list = userDetails.documents
              .where((element) => element.data['uid'] == uid)
              .first;

          if (list.data['role'] == 'customer') {
            if (list.data['signUpDone'] == true) {
              currentUser.updateCurrentUser(User(
                  email: list.data['email'],
                  name: list.data['name'],
                  role: list.data['role'],
                  uid: list.data['uid'],
                  signUpDone: list.data['signUpDone'],
                  geoPoint: list.data['geoPoint'],
                  userDocumentId: list.documentID,
                  userDocumentPath: list.reference.path));
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => CustomerSignUpFormPage(
                      uuid: uid, createdDocument: list.reference)));
            }
          } else {
            if (list.data['signUpDone'] == true) {
              currentUser.updateCurrentUser(User(
                  email: list.data['email'],
                  name: list.data['name'],
                  role: list.data['role'],
                  uid: list.data['uid'],
                  signUpDone: list.data['signUpDone'],
                  geoPoint: list.data['geoPoint'],
                  userDocumentId: list.documentID,
                  userDocumentPath: list.reference.path));
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => StoreSignUpFormPage(
                      uuid: uid, createdDocument: list.reference)));
            }
          }
        } catch (e) {
          print(e.toString());
          setState(() {
            isFormSubmitted = false;
          });
        }
      }
    }

    String validatePassword(String value) {
      if (value.isEmpty) {
        return 'Password Cant be empty';
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
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
                    obscureText: true,
                    onChanged: (password) => _password = password,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      return validatePassword(value);
                    },
                  ),
                  RaisedButton(
                    onPressed: isFormSubmitted == true ? null : login,
                    child: Text('Login'),
                  ),
                  if (isFormSubmitted) CircularProgressIndicator(),
                ],
              )),
        ),
      ),
    );
  }
}
