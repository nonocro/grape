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
          child: Column(
            children: [
              Expanded(
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
                    description: onBoardingData[index].description,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                      onBoardingData.length, (index) =>
                      Padding(padding: EdgeInsets.only(right: 8.0))
                  )
                ],
              )
            ],
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
        Flexible(
          child: Image.asset(
            "assets/images/gifs/location-pin.gif",
            fit: BoxFit.contain,
          ),
        ),
        Spacer(),
        Text(title, textAlign: TextAlign.center),
        Spacer(),
        Text(description),
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
    image: 'assets/images/gifs/location-pin.gif',
    title: "Localiser des vins près de vous",
    description:
        "Explorez une carte interactive pour trouver facilement des vins locaux autour de vous.",
  ),
  OnBoard(
    image: 'assets/images/gifs/search.gif',
    title: "Rechercher des vins par nom",
    description:
        "Trouvez rapidement votre vin préféré en effectuant une recherche par nom dans l’application.",
  ),
];
