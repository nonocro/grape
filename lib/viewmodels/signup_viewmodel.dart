
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> signUp() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      notifyListeners();
    }
  }
}
