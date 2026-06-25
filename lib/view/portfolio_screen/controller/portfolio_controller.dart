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
    _checkVisibility(aboutKey,      aboutVisible);
    _checkVisibility(skillsKey,     skillsVisible);
    _checkVisibility(projectsKey,   projectsVisible);
    _checkVisibility(experienceKey, experienceVisible);
    _checkVisibility(contactKey,    contactVisible);
  }

  /// Marks [obs] true when the widget attached to [key] enters the viewport.
  /// Uses a 15% threshold — section needs to be at least 15% visible.
  void _checkVisibility(GlobalKey key, RxBool obs) {
    if (obs.value) return; // once visible, stays visible

    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final viewportHeight =
        scrollController.position.viewportDimension;
    final scrollOffset = scrollController.offset;

    // position of the widget's top edge in scroll coordinates
    final widgetTop =
        box.localToGlobal(Offset.zero, ancestor: null).dy +
            scrollOffset -
            MediaQuery.of(ctx).padding.top;

    final widgetHeight = box.size.height;
    final threshold    = widgetHeight * 0.15;

    final visibleTop    = scrollOffset;
    final visibleBottom = scrollOffset + viewportHeight;

    if (widgetTop + threshold < visibleBottom &&
        widgetTop + widgetHeight > visibleTop) {
      obs.value = true;
    }
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