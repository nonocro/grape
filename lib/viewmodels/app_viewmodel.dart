
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
