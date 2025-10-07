import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart'; // Import Lottie
import 'package:grape/theme/app_colors_extension.dart'; // Assuming this is correct

class SplashScreen extends StatefulWidget {
  final Future<void> Function() loadData;
  const SplashScreen({super.key, required this.loadData});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // No need for AnimationController if Lottie handles the looping
  // late AnimationController _lottieController; // Uncomment if you need programmatic control

  @override
  void initState() {
    super.initState();

    // If you need to control Lottie animation (e.g., play once then navigate)
    // _lottieController = AnimationController(vsync: this);

    widget.loadData().then((_) {
      // Ensure the splash screen is visible for at least 2 seconds after data loads
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    });
  }

  @override
  void dispose() {
    // _lottieController.dispose(); // Uncomment if used
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColorsExtension? appColors = Theme.of(context).extension<AppColorsExtension>();
    final Color backgroundColor = appColors?.backgroundColor ?? Colors.white;
    // You might want to remove this line if your Lottie animation has its own colors
    // or if you want to explicitly override them using a Lottie composition.
    // final Color wineColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor, // Use your theme background color
      body: Center(
        child: Lottie.asset(
          'assets/animations/wine_pour.json', // Path to your Lottie JSON file
          // controller: _lottieController, // Assign if you need programmatic control
          onLoaded: (composition) {
            // _lottieController.duration = composition.duration; // Set duration from Lottie file
            // _lottieController.repeat(); // Loop the animation
          },
          fit: BoxFit.contain, // Adjust how the animation fits
          repeat: true, // Lottie will loop the animation by default
          reverse: false, // Don't play in reverse on repeat
          width: 300, // Adjust size as needed
          height: 300,
          // Add any other Lottie properties you need
        ),
      ),
    );
  }
}