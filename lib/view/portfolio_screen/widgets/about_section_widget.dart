import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});
  @override State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return VisibilityDetector(
      key: const Key('about'),
      onVisibilityChanged: (i) {
        if (i.visibleFraction > .12 && !_visible) setState(() => _visible = true);
      },
      child: Container(
        color: AppColors.bg,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80, vertical: 100),
        child: isMobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _left(isMobile), const SizedBox(height: 56), _cards(isMobile)])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _left(isMobile)),
          const SizedBox(width: 80),
          Expanded(child: _cards(isMobile)),
        ]),
      ),
    );
  }

  Widget _left(bool isMobile) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 800),
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(-.1, 0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // eyebrow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(99),
              color: AppColors.accent.withOpacity(.06),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              GlowDot(size: 6, color: AppColors.cyan),
              const SizedBox(width: 8),
              Text('How I work',
                  style: AppText.condensed(color: AppColors.accentLight, size: 11)),
            ]),
          ),

          const SizedBox(height: 24),
          AppText.gradient('Building apps\nthat matter.', AppText.heading(size: isMobile ? 36 : 44)),
          const SizedBox(height: 20),

          Text(
            'I take a structured, creative, and highly technical approach to turn ideas into robust cross-platform applications. Clean architecture and great UX aren\'t trade-offs — they\'re the baseline.',
            style: AppText.body(size: 15),
          ),

          const SizedBox(height: 32),

          // stats row
          Row(children: [
            _Stat(value: '3+',  label: 'Years Exp'),
            _divider(),
            _Stat(value: '6+',  label: 'Projects'),
            _divider(),
            _Stat(value: '3',   label: 'Packages'),
          ]),
        ]),
      ),
    );
  }

  Widget _divider() => Container(
    width: 1, height: 40, margin: const EdgeInsets.symmetric(horizontal: 24),
    decoration: const BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.accent, AppColors.cyan]),
    ),
  );

  Widget _cards(bool isMobile) {
    final data = [
      (num:'01', title:'Define', body:'Understanding requirements, user needs, and constraints to lay a solid foundation.', isAccent: true),
      (num:'02', title:'Design', body:'Clean architecture, intuitive UI and pixel-perfect Flutter interfaces that scale.', isAccent: false),
      (num:'03', title:'Build',  body:'Ship production-ready apps with clean code, tests, and real-world performance.', isAccent: false),
    ];
    return Column(
      children: data.asMap().entries.map((e) {
        final i = e.key; final c = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: i.isEven ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: .88,
              child: AnimatedOpacity(
                opacity: _visible ? 1 : 0,
                duration: Duration(milliseconds: 700 + i * 200),
                child: AnimatedSlide(
                  offset: _visible ? Offset.zero : Offset(i.isEven ? .1 : -.1, .05),
                  duration: Duration(milliseconds: 700 + i * 200),
                  curve: Curves.easeOutCubic,
                  child: _TiltCard(
                    num: c.num, title: c.title, body: c.body,
                    isAccent: c.isAccent, tilt: i.isEven ? .025 : -.02,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [AppColors.accentLight, AppColors.cyan],
        ).createShader(b),
        child: Text(value, style: const TextStyle(
          fontFamily: 'Barlow', fontWeight: FontWeight.w900,
          fontSize: 32, color: Colors.white,
        )),
      ),
      Text(label, style: AppText.condensed(color: AppColors.white, size: 10)),
    ],
  );
}

class _TiltCard extends StatefulWidget {
  final String num, title, body;
  final bool isAccent;
  final double tilt;
  const _TiltCard({required this.num, required this.title, required this.body,
    required this.isAccent, required this.tilt});
  @override State<_TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<_TiltCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.rotationZ(_hover ? 0 : widget.tilt)
          ..translate(0.0, _hover ? -6.0 : 0.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: widget.isAccent
              ? const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.accent, Color(0xFF5B21B6)])
              : null,
          color: widget.isAccent ? null : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isAccent ? Colors.transparent
                : (_hover ? AppColors.accentLight.withOpacity(.4) : AppColors.border),
          ),
          boxShadow: widget.isAccent || _hover ? [
            BoxShadow(
              color: widget.isAccent ? AppColors.accentGlow : AppColors.accentGlow.withOpacity(.3),
              blurRadius: _hover ? 32 : 24,
              offset: const Offset(0, 8),
            ),
          ] : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 10, height: 10,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: widget.isAccent ? Colors.white24 : AppColors.accent.withOpacity(.4))),
            const Spacer(),
            Text(widget.num,
                style: AppText.condensed(
                    color: widget.isAccent ? Colors.white30 : AppColors.textDim, size: 11)),
          ]),
          const SizedBox(height: 14),
          Text(widget.title,
              style: AppText.heading(
                  color: widget.isAccent ? Colors.white : AppColors.textPrimary, size: 22)),
          const SizedBox(height: 8),
          Text(widget.body,
              style: AppText.body(
                  color: widget.isAccent ? Colors.white70 : AppColors.textMuted, size: 13)),
        ]),
      ),
    );
  }
}
