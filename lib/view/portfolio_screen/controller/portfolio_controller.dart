import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioController extends GetxController {
  // Scroll
  final scrollController = ScrollController();
  final isNavScrolled = false.obs;

  // Section keys for scroll-to
  final heroKey       = GlobalKey();
  final aboutKey      = GlobalKey();
  final skillsKey     = GlobalKey();
  final projectsKey   = GlobalKey();
  final experienceKey = GlobalKey();
  final contactKey    = GlobalKey();

  // Section visibility for animations
  final aboutVisible      = false.obs;
  final skillsVisible     = false.obs;
  final projectsVisible   = false.obs;
  final experienceVisible = false.obs;
  final contactVisible    = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    isNavScrolled.value = scrollController.offset > 60;
  }

  void scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      alignment: 0.0,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
