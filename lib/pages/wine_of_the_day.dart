import 'package:flutter/material.dart';
import 'package:grape/theme/app_colors_extension.dart';

class WineOfTheDay extends StatelessWidget {
  const WineOfTheDay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppColorsExtension>()?.backgroundColor ?? Colors.black,
      body: Center(
        child: TextButton(onPressed: () {}, child: Text(
          'Vin du jour',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        )),
      ),
    );
  }
}