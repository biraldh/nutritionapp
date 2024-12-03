import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/editable_text.dart';

class LoginService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  Future<Object?> register({required String email, required String password, required String username}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await userCredential.user?.updateDisplayName(username);

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email.trim(),
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {

      return e.message ?? "An unknown error occurred";
    } catch (e) {
      return "An error occurred. Please try again.";
    }
  }
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
