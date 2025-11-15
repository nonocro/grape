import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/providers/wine_provider.dart';
import 'package:grape/utils/constants.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(wineListProvider, (_, next) {
      if (!next.isLoading) {
        Navigator.of(context).pushReplacementNamed(RouteNames.onboarding);
      }
    });

    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animations/wine_pour.json',
            width: 300, height: 300),
      ),
    );
  }
}
