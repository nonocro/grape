import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:grape/models/wine.dart';
import 'dart:math';

class MediumWineCard extends StatefulWidget {
  final Wine wine;
  final Color cardColor;
  final Color textColor;
  final bool skipAnimations;

  const MediumWineCard({
    super.key,
    required this.wine,
    required this.cardColor,
    required this.textColor,
    this.skipAnimations = false,
  });

  @override
  State<MediumWineCard> createState() => _MediumWineCardState();
}

class _MediumWineCardState extends State<MediumWineCard>
    with SingleTickerProviderStateMixin {
  double blurSigma = 10;
  int tapCount = 0;
  final int totalTaps = 3;

  late final AnimationController _controller;
  late final Animation<double> _shakeAnimation;

  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _confettiController = ConfettiController(duration: const Duration(seconds: 1));

    if (widget.skipAnimations) {
      blurSigma = 0;
      tapCount = totalTaps;
    }
  }

  void _onTap() {
    setState(() {
      if (widget.skipAnimations) return;
      tapCount++;
      blurSigma = ((10 * (totalTaps - tapCount)) / totalTaps).clamp(0, 10);

      // Shake à chaque tap tant que tapCount <= totalTaps
      if (tapCount <= totalTaps) {
        _controller.forward(from: 0);
      }

      // Au 3e tap, lancer le feu d’artifice via Overlay
      if (tapCount == totalTaps) {
        _showConfetti();
      }
    });
  }

  void _showConfetti() {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 500,
        left: MediaQuery.of(context).size.width / 2,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.orange,
            Colors.purple
          ],
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          gravity: 0.3,
        ),
      ),
    );

    overlay.insert(entry);

    _confettiController.play();

    Future.delayed(const Duration(seconds: 1), () {
      entry.remove();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 330,
                  decoration: BoxDecoration(
                    color: widget.cardColor,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30), bottom: Radius.circular(30)),
                  ),
                ),
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Positioned(
                      top: 10,
                      left: _shakeAnimation.value,
                      right: -_shakeAnimation.value,
                      child: child!,
                    );
                  },
                  child: Image.network(
                    widget.wine.image,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                // Texte du vin
                Positioned(
                  top: 310,
                  left: 16,
                  right: 16,
                  child: Builder(
                    builder: (context) {
                      final name = widget.wine.name;
                      const int headCount = 22;
                      const int tailCount = 4;
                      String displayName = name;
                      if (name.length > headCount + tailCount + 3) {
                        displayName =
                            '${name.substring(0, headCount)}\n...${name.substring(name.length - tailCount)}';
                      }
                      return Text(
                        displayName,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              color: widget.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
