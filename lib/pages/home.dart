import 'package:flutter/material.dart';
import 'package:grape/theme/app_colors_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppColorsExtension>()?.backgroundColor ?? Colors.black,
      body: Center(
        child: Text(
          'Accueil',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}