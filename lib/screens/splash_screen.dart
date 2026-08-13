import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/page_transitions.dart';
import 'main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _morphController;
  late final Animation<double> _morphCurve;

  // Flat colorful sport icons circling the logo, like the original splash:
  // headgear, mat, swimmer, band, glove, meditation, dumbbell-arm.
  static const _orbitEmojis = ["🥋", "🎽", "🏊", "⚡", "🥊", "🧘", "💪"];

  @override
  void initState() {
    super.initState();

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _morphCurve = CurvedAnimation(parent: _morphController, curve: Curves.easeOutBack);

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 1900));
    if (!mounted) return;
    await _morphController.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(slideUpRoute(const MainNavScreen()));
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_orbitController, _morphController]),
          builder: (context, _) {
            final morphT = _morphCurve.value;
            return SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Orbiting flat sport icons, fading out as the logo morphs.
                  Opacity(
                    opacity: (1 - morphT * 2).clamp(0.0, 1.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(_orbitEmojis.length, (i) {
                        final angle = (_orbitController.value * 2 * pi) +
                            (i * 2 * pi / _orbitEmojis.length) -
                            pi / 2;
                        const radius = 86.0;
                        final dx = radius * cos(angle);
                        final dy = radius * sin(angle);
                        return Transform.translate(
                          offset: Offset(dx, dy),
                          child: Transform.rotate(
                            angle: sin(_orbitController.value * 2 * pi + i) * 0.2,
                            child: Text(_orbitEmojis[i], style: const TextStyle(fontSize: 34)),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Logo: "1F" squircle morphing into the "1FIT" stadium pill,
                  // sizes and colors sampled from the original recording.
                  Container(
                    height: 93,
                    width: 93 + (73 * morphT),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24 + (22.5 * morphT)),
                    ),
                    alignment: Alignment.center,
                    child: ClipRect(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: (1 - morphT * 1.6).clamp(0.0, 1.0),
                            child: const Text("1F",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic)),
                          ),
                          Opacity(
                            opacity: ((morphT - 0.4) * 1.8).clamp(0.0, 1.0),
                            child: const Text("1FIT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.5,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
