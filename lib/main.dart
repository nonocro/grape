import 'package:flutter/material.dart';
import 'package:grape/pages/home.dart';
import 'package:grape/pages/wine_of_the_day.dart';
import 'package:grape/theme/app_colors_extension.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grape/components/auth_gate.dart';
import 'package:grape/firebase_options.dart';
import 'package:grape/pages/onboarding.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:grape/utils/constants.dart';
import 'components/splash_screen.dart';
import 'utils/app_initializer.dart' show AppInitializer;

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
  runApp(Home());
}

class Home extends StatelessWidget {
  const Home({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grape',
      theme: ThemeData(
        primarySwatch: customSwatch,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Inter',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontFamily: 'DM_Serif_Text', fontSize: 50),
          displayMedium: TextStyle(fontFamily: 'DM_Serif_Text', fontSize: 35),
          displaySmall: TextStyle(fontFamily: 'DM_Serif_Text', fontSize: 30),
          headlineLarge: TextStyle(fontFamily: 'DM_Serif_Text'),
          headlineMedium: TextStyle(fontFamily: 'DM_Serif_Text'),
          headlineSmall: TextStyle(fontFamily: 'DM_Serif_Text'),
          titleLarge: TextStyle(fontFamily: 'DM_Serif_Text'),
          titleMedium: TextStyle(fontFamily: 'DM_Serif_Text'),
          titleSmall: TextStyle(fontFamily: 'DM_Serif_Text'),
          bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 18),
          bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 16),
          bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 14),
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
        RouteNames.splash: (context) => SplashScreen(onLoad: AppInitializer.loadData),
        RouteNames.auth: (context) => AuthGate(),
        RouteNames.home: (context) => Home(), // '/home'
        RouteNames.onboarding: (context) => Onboarding() // '/onboarding'
      },
    );
  }
}
