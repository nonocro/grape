import 'package:flutter/material.dart';
import 'package:grape/theme/app_colors_extension.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/components/auth_gate.dart';
import 'package:grape/components/splash_screen.dart';
import 'package:grape/firebase_options.dart';
import 'package:grape/pages/base_page.dart';
import 'package:grape/pages/onboarding.dart';
import 'package:grape/utils/constants.dart';
import 'package:grape/pages/profile_page.dart';

const int primaryValue = 0xFF781818;
const Color primaryColor = Color(primaryValue);

const MaterialColor customSwatch = MaterialColor(
  primaryValue,
  <int, Color>{
    50: Color(0xFFEEECEC),
    100: Color(0xFFD4BDBD),
    200: Color(0xFFB98C8C),
    300: Color(0xFFA25C5C),
    400: Color(0xFF8B2C2C),
    500: primaryColor,
    600: Color(0xFF6C1515),
    700: Color(0xFF5E1212),
    800: Color(0xFF500F0F),
    900: Color(0xFF4E0F0F),
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: GrapeApp()));
}

class GrapeApp extends StatelessWidget {
  const GrapeApp ({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Grape',
        theme: ThemeData(
          primarySwatch: customSwatch,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Inter',
          textTheme: TextTheme(
            displayLarge: TextStyle(fontFamily: 'DM_Serif_Text'),
            displayMedium: TextStyle(fontFamily: 'DM_Serif_Text'),
            displaySmall: TextStyle(fontFamily: 'DM_Serif_Text'),
            headlineLarge: TextStyle(fontFamily: 'DM_Serif_Text'),
            headlineMedium: TextStyle(fontFamily: 'DM_Serif_Text'),
            headlineSmall: TextStyle(fontFamily: 'DM_Serif_Text'),
            titleLarge: TextStyle(fontFamily: 'DM_Serif_Text'),
            titleMedium: TextStyle(fontFamily: 'DM_Serif_Text'),
            titleSmall: TextStyle(fontFamily: 'DM_Serif_Text'),
          ),
          extensions: const <ThemeExtension<dynamic>>[
            AppColorsExtension(
              backgroundColor: Color(0xFFFAFAFA),
              cardColor: customSwatch,
              accentColor: Color(0xFFE5C65D),
            ),
          ],
        ),
        initialRoute: RouteNames.splash,
        routes: {
          RouteNames.splash: (context) => SplashScreen(),
          RouteNames.auth: (context) => AuthGate(),
          RouteNames.home: (context) => BasePage(), // base avec la bottomNavBar
          RouteNames.onboarding: (context) => Onboarding(),
          RouteNames.profile: (context) => ProfilePage(),
        },
    );
  }
}
