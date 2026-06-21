import 'package:flutter/material.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});
  @override State<ExperienceSection> createState() => _ExperienceSectionState();
}
class _ExperienceSectionState extends State<ExperienceSection> {
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return VisibilityDetector(
      key: const Key('experience'),
      onVisibilityChanged: (i) { if (i.visibleFraction > .1 && !_visible) setState(() => _visible = true); },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.bg, Color(0xFF0A0820), AppColors.bg]),
        ),
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80, vertical: 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('CAREER', style: AppText.condensed(color: AppColors.cyan, size: 11)),
          const SizedBox(height: 10),
          AppText.gradient('Work Experience', AppText.heading(size: 42)),
          const SizedBox(height: 48),
          // timeline line
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (!isMobile) ...[
                Column(children: [
                  GlowDot(),
                  Expanded(child: Container(width: 1,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [AppColors.accent, AppColors.cyan]),
                    ),
                  )),
                  GlowDot(color: AppColors.cyan),
                ]),
                const SizedBox(width: 40),
              ],
              Expanded(child: Column(children: [
                _ExpItem(period: '2025 — Present', role: 'Flutter Developer',
                    company: 'Taraz WebGostar Samane Co',
                    desc: 'Building an ERP web application to optimize organizational processes and enhance productivity. Focused on Clean Architecture and performance.',
                    visible: _visible, delay: 0, isMobile: isMobile),
                Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 32),
                    decoration: const BoxDecoration(gradient: LinearGradient(
                        colors: [AppColors.accent, AppColors.cyan]))),
                _ExpItem(period: '2023 — 2025', role: 'Flutter Developer',
                    company: 'Payam Gostar Fava Co',
                    desc: 'Developed an attendance system, delivery app, and restaurant CRM. Collaborated cross-functionally to improve app performance and UX.',
                    visible: _visible, delay: 150, isMobile: isMobile),
              ])),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ExpItem extends StatelessWidget {
  final String period, role, company, desc;
  final bool visible, isMobile; final int delay;
  const _ExpItem({required this.period, required this.role, required this.company,
    required this.desc, required this.visible, required this.delay, required this.isMobile});
  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: visible ? 1 : 0, duration: Duration(milliseconds: 700 + delay),
    child: isMobile
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(period, style: AppText.condensed(color: AppColors.textMuted, size: 11)),
      const SizedBox(height: 10), _content(),
    ])
        : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 160, child: Text(period, style: AppText.condensed(color: AppColors.textMuted, size: 11))),
      const SizedBox(width: 32),
      Expanded(child: _content()),
    ]),
  );
  Widget _content() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(role, style: AppText.heading(size: 22)),
    const SizedBox(height: 4),
    Text(company, style: AppText.condensed(color: AppColors.accentLight, size: 12)),
    const SizedBox(height: 10),
    Text(desc, style: AppText.body(size: 14)),
  ]);
}
