import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stateDemo/Pages/CustomerPages/CustomerSignUpFormPage.dart';
import 'package:stateDemo/Pages/StorePages/StoreSignUpFormPage.dart';
import 'package:stateDemo/Services/FirebaseAuthService.dart';

class SignUpPage extends StatefulWidget {
  final String userType;

  SignUpPage({@required this.userType});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool isFormSubmitted = false;
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  Future<DocumentReference> createCustomer(String uuid) async {
    return await Firestore.instance
        .collection('customers')
        .add({'uid': uuid, 'signUpDone': false});
  }

  signUp() async {
    if (true) {
      try {
        setState(() {
          isFormSubmitted = true;
        });
        AuthResult authResult = await _firebaseAuthService
            .signUpWithEmailAndPassword(_email, _password);
        print(authResult.user);
        DocumentReference userDoc = await createCustomer(authResult.user.uid);
        Navigator.of(context).pop();
        if(widget.userType == 'customer') {
            Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomerSignUpFormPage(
            uuid: authResult.user.uid,
            createdDocument: userDoc,
          ),
        ));
        } else {
            Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StoreSignUpFormPage(
            uuid: authResult.user.uid,
            createdDocument: userDoc,
          ),
        ));
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
    } else {
      if (value.length < 6) return 'Password must be atleast 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Page'),
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
                    onPressed: isFormSubmitted == true ? null : signUp,
                    child: Text('SignUp'),
                  ),
                  if (isFormSubmitted) CircularProgressIndicator(),
                ],
              )),
        ),
      ),
    );
  }
}
