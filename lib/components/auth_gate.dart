
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grape/pages/base_page.dart';
import 'package:grape/pages/sign_in.dart';


/**
 * Détermine si l'utilisateur est authentifié ou non
 * redirige vers la page de connexion ou la page d'accueil en conséquence
 */
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>( 
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignIn();
        }
        return BasePage();
      },
    );
  }
}
