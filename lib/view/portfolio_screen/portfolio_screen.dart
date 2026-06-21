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
            HeroSection(key: ctrl.heroKey)
                .animate().fadeIn(duration: 600.ms),
            AboutSection(key: ctrl.aboutKey),
            SkillsSection(key: ctrl.skillsKey),
            ProjectsSection(key: ctrl.projectsKey),
            ExperienceSection(key: ctrl.experienceKey),
            ContactSection(key: ctrl.contactKey),
            _Footer(),
          ]),
        ),

        // ── fixed nav ──
        Obx(() => NavBar(
          isScrolled: ctrl.isNavScrolled.value,
          onNav: ctrl.scrollToSection,
          heroKey:       ctrl.heroKey,
          aboutKey:      ctrl.aboutKey,
          skillsKey:     ctrl.skillsKey,
          projectsKey:   ctrl.projectsKey,
          experienceKey: ctrl.experienceKey,
          contactKey:    ctrl.contactKey,
        )),
      ]),
    );
  }
}

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
          child: const Text('hh.', style: TextStyle(
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
