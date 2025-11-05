
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grape/components/auth_gate.dart';
import 'package:grape/firebase_options.dart';
import 'package:grape/pages/home.dart';
import 'package:grape/services/wine.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'components/splash_screen.dart';

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
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<void> _loadData() async {
    await fetchRedWines();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: MaterialApp(
        title: 'Grape',
        theme: ThemeData(
          primarySwatch: customSwatch,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Inter',
          textTheme: TextTheme(
            displayLarge: TextStyle(fontFamily: 'ClimateCrisis'),
            displayMedium: TextStyle(fontFamily: 'ClimateCrisis'),
            displaySmall: TextStyle(fontFamily: 'ClimateCrisis'),
            headlineLarge: TextStyle(fontFamily: 'ClimateCrisis'),
            headlineMedium: TextStyle(fontFamily: 'ClimateCrisis'),
            headlineSmall: TextStyle(fontFamily: 'ClimateCrisis'),
            titleLarge: TextStyle(fontFamily: 'ClimateCrisis'),
            titleMedium: TextStyle(fontFamily: 'ClimateCrisis'),
            titleSmall: TextStyle(fontFamily: 'ClimateCrisis'),
          ),
          extensions: const <ThemeExtension<dynamic>>[
            AppColorsExtension(
              backgroundColor: Color(0xFFFAFAFA),
              cardColor: Colors.white,
              accentColor: Color(0xFFE5C65D),
            ),
          ],
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(loadData: _loadData),
          '/auth': (context) => AuthGate(),
          '/home': (context) => Home(),
        },
      ),
    );
  }
}
