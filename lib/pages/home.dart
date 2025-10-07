import 'package:flutter/material.dart';
import 'package:grape/pages/wine_of_the_day.dart';
import 'package:grape/theme/app_colors_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppColorsExtension>()?.backgroundColor ?? Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Text(
          'Accueil',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            print("test");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WineOfTheDay()),
            );
          },
          child: const Text('Voir le vin du jour'),
        ),
          ],
        ),
      ),
    );
  }
}