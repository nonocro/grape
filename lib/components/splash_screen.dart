import 'package:flutter/material.dart';
import 'package:grape/utils/constants.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import '../utils/app_initializer.dart';

class SplashScreen extends StatefulWidget {
  final Future<void> Function() onLoad;
  final Duration minDisplayDuration;

  const SplashScreen({
    super.key,
    required this.onLoad,
    this.minDisplayDuration = const Duration(seconds: 6),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startAppFlow();
  }

  Future<void> _startAppFlow() async {
    await Future.wait([
      widget.onLoad(),
      Future.delayed(widget.minDisplayDuration),
    ]);

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(RouteNames.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animations/wine_pour.json',
            width: 300, height: 300),
      ),
    );
  }
}
