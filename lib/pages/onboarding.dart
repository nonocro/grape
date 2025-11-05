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

  void _nextPage() {
    if (_pageIndex < onBoardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Ici tu peux naviguer vers ton écran principal (home / login)
      Navigator.pushReplacementNamed(context, '/home');
    }
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onBoardingData.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 8),
                    height: 8,
                    width: _pageIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _pageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Bouton suivant / terminer
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _nextPage,
                child: Text(
                  _pageIndex == onBoardingData.length - 1
                      ? "Commencer"
                      : "Suivant",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
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
          flex: 3,
          child: Image.asset(
            image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.white),
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
