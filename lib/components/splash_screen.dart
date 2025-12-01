import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/providers/wine_provider.dart';
import 'package:grape/utils/constants.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding =
            prefs.getBool(kOnboardingCompletedKey) ?? false;

    final dataLoaded = ref.read(wineListProvider.future);
    final minTimePassed = Future.delayed(const Duration(seconds: 6));

    await Future.wait([dataLoaded, minTimePassed]);

     if (!mounted) return;

      if (!hasCompletedOnboarding) {
        Navigator.pushReplacementNamed(context, RouteNames.onboarding);
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.auth);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppColorsExtension>()?.accentColor ?? Colors.amber,
      body: Center(
        child: Lottie.asset('assets/animations/wine_pour.json',
            width: 300, height: 300),
      ),
    );
  }
}
