import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ─────────────────────────────────────────────
//  Data
// ─────────────────────────────────────────────
const _skills = [
  _Skill('Flutter & Dart', 'Cross-platform mobile & web', Icons.phone_android_rounded),
  _Skill('State Management', 'Bloc · Provider · GetX', Icons.account_tree_rounded),
  _Skill('Architecture', 'MVC · MVVM · Clean', Icons.layers_rounded),
  _Skill('Networking & API', 'Dio · DartZ · Freezed', Icons.wifi_rounded),
  _Skill('Local Storage', 'SQLite · Hive · SharedPrefs', Icons.storage_rounded),
  _Skill('Platform Integration', 'MethodChannel · Firebase', Icons.integration_instructions_rounded),
  _Skill('Maps & Location', 'Flutter Map · Geolocator', Icons.map_rounded),
  _Skill('Tooling', 'Figma · Git · Material UI', Icons.build_rounded),
];

class _Skill {
  final String name, sub;
  final IconData icon;
  const _Skill(this.name, this.sub, this.icon);
}

// ─────────────────────────────────────────────
//  Section
// ─────────────────────────────────────────────
class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late final AnimationController _headerCtrl;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, .2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  void _onVisible(VisibilityInfo info) {
    if (info.visibleFraction > .1 && !_visible) {
      setState(() => _visible = true);
      _headerCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return VisibilityDetector(
      key: const Key('skills'),
      onVisibilityChanged: _onVisible,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bg, Color(0xFF0D0B2E), AppColors.bg],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80,
          vertical: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── header ──────────────────────────────────
            FadeTransition(
              opacity: _headerFade,
              child: SlideTransition(
                position: _headerSlide,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.cyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'EXPERTISE',
                          style: AppText.condensed(
                              color: AppColors.cyan, size: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppText.gradient('Skills & Tools', AppText.heading(size: 42)),
                    const SizedBox(height: 8),
                    Text(
                      'Technologies I work with every day',
                      style: AppText.body(
                          color: AppColors.textDim, size: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 48),

            // ── grid ────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 4,
                childAspectRatio: isMobile ? 5 : 2.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _skills.length,
              itemBuilder: (_, i) => _SkillCard(
                skill: _skills[i],
                visible: _visible,
                delay: 150 + i * 80,
                index: i,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Card
// ─────────────────────────────────────────────
class _SkillCard extends StatefulWidget {
  final _Skill skill;
  final bool visible;
  final int delay;
  final int index;

  const _SkillCard({
    required this.skill,
    required this.visible,
    required this.delay,
    required this.index,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;
  late final Animation<double> _glowPulse;

  // accent colours cycling per card
  static const _accents = [
    [AppColors.accent, AppColors.cyan],
    [Color(0xFF7C3AED), AppColors.accent],
    [AppColors.cyan, Color(0xFF06B6D4)],
    [Color(0xFF059669), AppColors.cyan],
  ];

  List<Color> get _cardAccent =>
      _accents[widget.index % _accents.length];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, .35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _scale = Tween<double>(begin: .88, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _glowPulse = Tween<double>(begin: .4, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(.5, 1, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didUpdateWidget(_SkillCard old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _hovered
                    ? const Color(0xFF16133A)
                    : const Color(0xFF0F0D28),
                border: Border.all(
                  color: _hovered
                      ? _cardAccent[0].withOpacity(.7)
                      : AppColors.border,
                  width: _hovered ? 1.5 : 1,
                ),
                boxShadow: _hovered
                    ? [
                  BoxShadow(
                    color: _cardAccent[0].withOpacity(.25),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: _cardAccent[1].withOpacity(.12),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ]
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    // ── background gradient blob ──────
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      top: _hovered ? -20 : 40,
                      right: _hovered ? -10 : 30,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: _hovered ? 90 : 50,
                        height: _hovered ? 90 : 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _cardAccent[0].withOpacity(_hovered ? .18 : .07),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── top accent line ───────────────
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: _hovered ? 2 : 0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: _cardAccent),
                      ),
                    ),

                    // ── content ───────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // icon box
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _cardAccent[0].withOpacity(
                                      _hovered ? .22 : .12),
                                  _cardAccent[1].withOpacity(
                                      _hovered ? .15 : .06),
                                ],
                              ),
                              border: Border.all(
                                color: _cardAccent[0]
                                    .withOpacity(_hovered ? .45 : .18),
                              ),
                            ),
                            child: Icon(
                              widget.skill.icon,
                              size: 20,
                              color: _hovered
                                  ? _cardAccent[0]
                                  : _cardAccent[0].withOpacity(.65),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.skill.name,
                                  style: AppText.condensed(
                                    color: AppColors.textPrimary,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  widget.skill.sub,
                                  style: AppText.body(
                                    color: const Color(0xFFAAABBF),
                                    size: 11.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── corner glow decoration ────────
                    if (_hovered)
                      Positioned(
                        bottom: -12,
                        left: -12,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                _cardAccent[1].withOpacity(.15),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(Color c) => Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );
}

// ─────────────────────────────────────────────
//  Spinning border painter (optional accent)
//  Usage: wrap any widget with _SpinningBorder
// ─────────────────────────────────────────────
class _SpinningBorder extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  const _SpinningBorder({required this.child, required this.colors});

  @override
  State<_SpinningBorder> createState() => _SpinningBorderState();
}

class _SpinningBorderState extends State<_SpinningBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => CustomPaint(
        painter: _BorderPainter(_ctrl.value, widget.colors),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _BorderPainter extends CustomPainter {
  final double t;
  final List<Color> colors;
  _BorderPainter(this.t, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
    Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

    final sweep = math.pi * .8;
    final start = 2 * math.pi * t;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: [...colors, Colors.transparent],
      ).createShader(rect);

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(_BorderPainter old) => old.t != t;
}
