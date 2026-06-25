import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:hadi_portfolio/view/portfolio_screen/controller/portfolio_controller.dart';
import 'package:hadi_portfolio/view/portfolio_screen/widgets/about_section_widget.dart';
import 'package:hadi_portfolio/view/portfolio_screen/widgets/contact_section_widget.dart';
import 'package:hadi_portfolio/view/portfolio_screen/widgets/experience_section_widget.dart';
import 'package:hadi_portfolio/view/portfolio_screen/widgets/hero_section_widget.dart';
import 'package:hadi_portfolio/view/portfolio_screen/widgets/nav_bar_widget.dart';
import 'package:hadi_portfolio/view/portfolio_screen/widgets/projects_section_widget.dart';
import 'package:hadi_portfolio/view/portfolio_screen/widgets/skill_section_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(PortfolioController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(children: [
        // ── scrollable content ──
        SingleChildScrollView(
          controller: ctrl.scrollController,
          child: Column(children: [
            // Hero — always visible, animates on page load
            HeroSection(key: ctrl.heroKey).animate().fadeIn(duration: 600.ms),

            // About
            Obx(() => _SectionReveal(
                  visible: ctrl.aboutVisible.value,
                  child: AboutSection(key: ctrl.aboutKey),
                )),

            // Skills
            Obx(() => _SectionReveal(
                  visible: ctrl.skillsVisible.value,
                  child: SkillsSection(key: ctrl.skillsKey),
                )),

            // Projects
            Obx(() => _SectionReveal(
                  visible: ctrl.projectsVisible.value,
                  child: ProjectsSection(key: ctrl.projectsKey),
                )),

            // Experience
            Obx(() => _SectionReveal(
                  visible: ctrl.experienceVisible.value,
                  child: ExperienceSection(key: ctrl.experienceKey),
                )),

            // Contact
            Obx(() => _SectionReveal(
                  visible: ctrl.contactVisible.value,
                  child: ContactSection(key: ctrl.contactKey),
                )),

            _Footer(),
          ]),
        ),

        // ── fixed nav ──
        Obx(() => NavBar(
              isScrolled: ctrl.isNavScrolled.value,
              onNav: ctrl.scrollToSection,
              heroKey: ctrl.heroKey,
              aboutKey: ctrl.aboutKey,
              skillsKey: ctrl.skillsKey,
              projectsKey: ctrl.projectsKey,
              experienceKey: ctrl.experienceKey,
              contactKey: ctrl.contactKey,
            )),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Reusable scroll-reveal wrapper
// ─────────────────────────────────────────────
class _SectionReveal extends StatefulWidget {
  final bool visible;
  final Widget child;

  const _SectionReveal({required this.visible, required this.child});

  @override
  State<_SectionReveal> createState() => _SectionRevealState();
}

class _SectionRevealState extends State<_SectionReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(_SectionReveal old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) {
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: widget.child,
        ),
      );
}

// ─────────────────────────────────────────────
//  Footer
// ─────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.bg,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [AppColors.accentLight, AppColors.cyan],
              ).createShader(b),
              child: const Text('hh.',
                  style: TextStyle(
                    fontFamily: 'BarlowCondensed',
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.white,
                  )),
            ),
            Text('© 2025 HADI HAZARI · FLUTTER DEVELOPER',
                style: AppText.condensed(color: AppColors.textDim, size: 10)),
            GlowDot(size: 6, color: AppColors.cyan),
          ],
        ),
      );
}
