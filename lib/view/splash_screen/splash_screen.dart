import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:hadi_portfolio/view/portfolio_screen/portfolio_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bar;
  late Animation<double> _barAnim;
  bool _fadeOut = false;

  @override
  void initState() {
    super.initState();
    _bar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _barAnim = CurvedAnimation(parent: _bar, curve: Curves.easeInOutCubic);

    _bar.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _fadeOut = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      Get.off(() => const HomeScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 600),
      );
    });
  }

  @override
  void dispose() { _bar.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedOpacity(
      opacity: _fadeOut ? 0 : 1,
      duration: const Duration(milliseconds: 600),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Stack(fit: StackFit.expand, children: [

          // glow orbs
          Positioned(top: -120, right: -120,
              child: Container(width: 500, height: 500,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppColors.accent.withOpacity(.15), Colors.transparent])))),
          Positioned(bottom: -100, left: -100,
              child: Container(width: 360, height: 360,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppColors.cyan.withOpacity(.10), Colors.transparent])))),

          // stars
          ..._buildStars(size),

          // center
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              // logo با gradient
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [AppColors.accentLight, AppColors.cyan],
                ).createShader(b),
                child: const Text('hh.', style: TextStyle(
                  fontFamily: 'BarlowCondensed',
                  fontWeight: FontWeight.w900,
                  fontSize: 80,
                  color: Colors.white,
                  letterSpacing: -3,
                )),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: .4, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),

              const SizedBox(height: 12),

              Text('FLUTTER DEVELOPER',
                style: AppText.condensed(color: AppColors.textDim, size: 11),
              ).animate(delay: 400.ms).fadeIn(duration: 600.ms),

              const SizedBox(height: 56),

              // bar
              SizedBox(width: 260, child: Column(children: [
                AnimatedBuilder(
                  animation: _barAnim,
                  builder: (_, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: _barAnim.value,
                      minHeight: 2,
                      backgroundColor: Colors.white.withOpacity(.05),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('INITIALIZING',
                  style: AppText.condensed(color: AppColors.textDim, size: 10),
                ).animate(delay: 400.ms).fadeIn(),
              ])).animate(delay: 300.ms).fadeIn(duration: 600.ms),

            ]),
          ),

          // bottom
          Positioned(bottom: 32, left: 0, right: 0,
            child: Center(
              child: Text('HADI HAZARI · TEHRAN',
                style: AppText.condensed(color: AppColors.textDim, size: 10),
              ).animate(delay: 1000.ms).fadeIn(duration: 700.ms),
            ),
          ),
        ]),
      ),
    );
  }

  List<Widget> _buildStars(Size size) {
    final pts = [
      [.08,.12,.8],[.85,.18,1.2],[.25,.72,1.0],[.92,.58,.7],
      [.5,.08,1.5],[.14,.88,.9],[.72,.92,1.1],[.6,.38,.6],
      [.33,.5,.8],[.78,.28,1.3],
    ];
    return pts.map((p) {
      final sz = p[2] * 2.5;
      return Positioned(
        left: size.width * p[0], top: size.height * p[1],
        child: Container(width: sz, height: sz,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(.15 + p[1] * .15),
            boxShadow: [BoxShadow(color: AppColors.accentLight.withOpacity(.3), blurRadius: 4)],
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fadeIn(duration: Duration(milliseconds: (800 + p[0] * 2000).toInt()))
            .then()
            .fadeOut(duration: Duration(milliseconds: (600 + p[1] * 1500).toInt())),
      );
    }).toList();
  }
}
