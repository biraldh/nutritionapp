import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/editable_text.dart';

class LoginService {
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

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Return error message for display
      return e.message ?? "An unknown error occurred";
    } catch (e) {
      return "An error occurred. Please try again.";
    }
  }
}
