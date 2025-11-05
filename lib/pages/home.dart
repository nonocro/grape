import 'package:flutter/material.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppColorsExtension>()?.backgroundColor ?? Colors.black,
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<HomeViewModel>(context, listen: false).signOut();
            },
          ),
        ],
      ),
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