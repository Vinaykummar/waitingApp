import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<AuthResult> signUpWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut(String email, String password) {
    return _firebaseAuth.signOut();
  }

  Future<void> forgotPassword(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}