import 'package:flutter/material.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _visible = false;
  static const _skills = [
    ('Flutter & Dart', 'Cross-platform mobile & web'),
    ('State Management', 'Bloc · Provider · GetX'),
    ('Architecture', 'MVC · MVVM · Clean'),
    ('Networking & API', 'Dio · DartZ · Freezed'),
    ('Local Storage', 'SQLite · Hive · SharedPrefs'),
    ('Platform Integration', 'MethodChannel · Firebase'),
    ('Maps & Location', 'Flutter Map · Geolocator'),
    ('Tooling', 'Figma · Git · Material UI'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return VisibilityDetector(
      key: const Key('skills'),
      onVisibilityChanged: (i) {
        if (i.visibleFraction > .1 && !_visible)
          setState(() => _visible = true);
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.bg, Color(0xFF0D0B2E), AppColors.bg]),
        ),
        padding:
            EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80, vertical: 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('EXPERTISE',
              style: AppText.condensed(color: AppColors.cyan, size: 11)),
          const SizedBox(height: 10),
          AppText.gradient('Skills & Tools', AppText.heading(size: 42)),
          const SizedBox(height: 48),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.hardEdge,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 4,
                childAspectRatio: isMobile ? 4 : 1.6,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: _skills.length,
              itemBuilder: (_, i) => _SkillCard(
                  name: _skills[i].$1,
                  sub: _skills[i].$2,
                  visible: _visible,
                  delay: i * 60),
            ),
          ),
        ]),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final String name, sub;
  final bool visible;
  final int delay;

  const _SkillCard(
      {required this.name,
      required this.sub,
      required this.visible,
      required this.delay});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _h ? AppColors.bgHover : AppColors.bgCard,
            border: Border(
                top: BorderSide(
                    color: _h ? AppColors.accent : Colors.transparent,
                    width: 2)),
            boxShadow: _h
                ? [
                    BoxShadow(
                        color: AppColors.accentGlow.withOpacity(.5),
                        blurRadius: 16)
                  ]
                : null,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.accent, AppColors.cyan]),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                Text(widget.name,
                    style: AppText.condensed(
                        color: AppColors.textPrimary, size: 12)),
                const SizedBox(height: 4),
                Text(widget.sub,
                    style: AppText.body(color: AppColors.textDim, size: 11)),
              ]),
        ),
      );
}
