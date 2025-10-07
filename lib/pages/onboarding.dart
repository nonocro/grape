import 'package:flutter/material.dart';

import '../theme/app_colors_extension.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).extension<AppColorsExtension>()?.backgroundColor ??
          Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: PageView.builder(
            itemCount: onBoardingData.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _pageIndex = index;
              });
            },
            itemBuilder: (context, index) => OnBoardingContent(
              image: onBoardingData[index].image,
              title: onBoardingData[index].title,
              description: onBoardingData[index].description
            ),
          ),
        ),
      ),
    );
  }
}

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Image.asset(
          image,
          height: 250,
        ),
        Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Text(
          description
        )
      ],
    );
  }
}

/**
 * Structure pour les pages de onboarding
 */
class OnBoard {
  final String image, title, description;

  OnBoard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnBoard> onBoardingData = [
  OnBoard(
    image: 'image',
    title: "Find Some WIne",
    description: "Fine some win within the application ",
  ),
  OnBoard(
    image: 'image',
    title: "Localisation des vins",
    description:
        "La carte interactive permet de localiser facilement les vins locaux",
  ),
];
