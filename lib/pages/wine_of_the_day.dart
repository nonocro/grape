import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grape/components/wine_of_the_day/medium_wine_card.dart';
import 'package:grape/pages/wine_details.dart';
import '../models/wine.dart';
import '../services/wine_of_the_day.dart';
import 'package:grape/theme/app_colors_extension.dart';

// Provider du service
final wineOfTheDayServiceProvider = Provider<WineOfTheDayService>((ref) {
  return WineOfTheDayService(ref);
});

class WineOfTheDay extends ConsumerStatefulWidget {
  const WineOfTheDay({super.key});

  @override
  ConsumerState<WineOfTheDay> createState() => _WineOfTheDayState();
}

class _WineOfTheDayState extends ConsumerState<WineOfTheDay>
    with TickerProviderStateMixin {
  late final WineOfTheDayService wineService;
  Wine? currentWine;
  bool isLoading = true;
  bool alreadyDiscovered = false;

  late AnimationController _verticalController;
  late AnimationController _horizontalController;

  @override
  void initState() {
    super.initState();

    // Récupérer le service via Riverpod après le premier frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      wineService = ref.read(wineOfTheDayServiceProvider);
      _loadWine();
    });

    _verticalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _horizontalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  Future<void> _loadWine() async {
    if (!mounted) return;

    final discovered = await wineService.isWineAlreadyDiscovered();
    final wine = await wineService.getWineOfTheDay();

    if (!mounted) return;

    setState(() {
      currentWine = wine;
      alreadyDiscovered = discovered;
      isLoading = false;
    });

    _verticalController.forward();
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                AnimatedBuilder(
                  animation:
                      Listenable.merge([_verticalController, _horizontalController]),
                  builder: (context, child) {
                    return ClipPath(
                      clipper: AnimatedWavyClipper(
                        progress: _verticalController.value,
                        phase: _horizontalController.value * 2 * pi,
                      ),
                      child: Container(
                        color: colors.accentColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 110.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Vin du jour',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          color: colors.cardColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Revenez ici chaque jour pour découvrir un nouveau vin ! 🍇🍷',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: MediumWineCard(
                                      key: ValueKey(currentWine?.id),
                                      wine: currentWine!,
                                      cardColor: colors.cardColor,
                                      textColor: Colors.white,
                                      skipAnimations: alreadyDiscovered,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WineDetailsPage(wine: currentWine!),
                                        ),
                                      );
                                      //wineService.reset();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.cardColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      'En savoir plus',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}

class AnimatedWavyClipper extends CustomClipper<Path> {
  final double progress;
  final double phase;
  final int waves;
  final double amplitude;

  AnimatedWavyClipper({
    required this.progress,
    required this.phase,
    this.waves = 2,
    this.amplitude = 20.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final double waveProgress = progress * 0.9;
    path.moveTo(0, size.height);

    final Random rand = Random();

    for (double x = 0; x <= size.width; x++) {
      double y = size.height * (1 - waveProgress) +
          sin((x / size.width * waves * pi * waveProgress) + phase) * amplitude;
      y += (rand.nextDouble() - 0.5) * 2;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant AnimatedWavyClipper oldClipper) => true;
}
