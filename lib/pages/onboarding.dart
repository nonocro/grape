import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

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

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingCompletedKey, true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.auth);
  }

  void _nextPage() {
    if (_pageIndex < onBoardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.white;
    final accentColor = Theme.of(context).primaryColor;
    final textColor = Colors.black; // ou Colors.white si le bg est foncé

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    textColor: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onBoardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 8),
                    height: 6,
                    width: _pageIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _pageIndex == index
                          ? accentColor
                          : accentColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: bgColor,
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
    required this.textColor,
  });

  final String image, title, description;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Flexible(
          flex: 3,
          child: Image.asset(
            image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.broken_image, color: textColor),
          ),
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const Spacer(),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ],
    );
  }
}

/// Structure pour les pages de onboarding
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
