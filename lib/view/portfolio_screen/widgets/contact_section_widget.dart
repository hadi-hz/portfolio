import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});
  @override State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return VisibilityDetector(
      key: const Key('contact'),
      onVisibilityChanged: (i) {
        if (i.visibleFraction > .05 && !_visible) setState(() => _visible = true);
      },
      child: Container(
        color: AppColors.bg,
        child: Stack(children: [

          // ── glow behind giant text ──
          Positioned(top: 0, left: 0, right: 0,
            child: Container(
              height: isMobile ? size.width * .8 : size.width * .3,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter, radius: 1,
                  colors: [AppColors.accent.withOpacity(.1), Colors.transparent],
                ),
              ),
            ),
          ),

          // ── giant background text ──
          Positioned(top: 0, left: 0, right: 0,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('CONTACT', style: TextStyle(
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary.withOpacity(.07),
                fontSize: 200,
                height: .85,
              )),
            ),
          ),

          // ── contact panel ──
          Padding(
            padding: EdgeInsets.only(
              top: isMobile ? size.width * .5 : size.width * .18,
            ),
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 800),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF120D30), Color(0xFF0D1828)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28), topRight: Radius.circular(28),
                  ),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(color: AppColors.accentGlow, blurRadius: 60, offset: const Offset(0,-12)),
                  ],
                ),
                padding: EdgeInsets.all(isMobile ? 28 : 56),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // header
                  Row(children: [
                    GlowDot(color: AppColors.cyan),
                    const SizedBox(width: 10),
                    Text("LET'S CONNECT",
                        style: AppText.condensed(color: AppColors.cyan, size: 11)),
                  ]),
                  const SizedBox(height: 12),
                  AppText.gradient("Get in Touch", AppText.heading(size: isMobile ? 32 : 42)),
                  const SizedBox(height: 8),
                  Text(
                    "Have a project in mind? Let's build something great together.",
                    style: AppText.body(color: AppColors.textMuted, size: 14),
                  ),
                  const SizedBox(height: 40),

                  // contact cards grid
                  isMobile
                      ? Column(children: _contactCards(isMobile))
                      : Row(children: _contactCards(isMobile)
                      .map((w) => Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6), child: w)))
                      .toList()),

                  const SizedBox(height: 40),

                  // divider
                  const GradientDivider(),

                  const SizedBox(height: 32),

                  // availability badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.bgHover,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF22c55e),
                            boxShadow: [BoxShadow(
                              color: const Color(0xFF22c55e).withOpacity(.7),
                              blurRadius: 8,
                            )],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Available for new projects',
                            style: AppText.body(color: AppColors.textPrimary, size: 13)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  List<Widget> _contactCards(bool isMobile) => [
    _ContactCard(
      icon: Icons.email_outlined,
      label: 'Gmail',
      value: 'hhazari519@gmail.com',
      sub: 'Drop me an email',
      gradient: const [Color(0xFFEA4335), Color(0xFFFBBC04)],
      onTap: () => _copy('hhazari519@gmail.com', 'Email copied!'),
    ),
    SizedBox(height: isMobile ? 12 : 0, width: isMobile ? 0 : 12),
    _ContactCard(
      icon: Icons.code_rounded,
      label: 'GitHub',
      value: 'hadi_hz',
      sub: 'Check my repositories',
      gradient: const [Color(0xFF6e40c9), Color(0xFF8250df)],
      onTap: () => _copy('github.com/hadi_hz', 'GitHub copied!'),
    ),
    SizedBox(height: isMobile ? 12 : 0, width: isMobile ? 0 : 12),
    _ContactCard(
      icon: Icons.phone_outlined,
      label: 'Phone',
      value: '+98 904 660 7983',
      sub: 'Call or WhatsApp',
      gradient: [AppColors.accent, AppColors.cyan],
      onTap: () => _copy('+989046607983', 'Phone copied!'),
    ),
  ];

  void _copy(String text, String msg) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('',msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.bgCard,
      colorText: AppColors.accentLight,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}

// ignore: must_be_immutable
class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String label, value, sub;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon, required this.label,
    required this.value, required this.sub,
    required this.gradient, required this.onTap,
  });

  @override State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard>
    with SingleTickerProviderStateMixin {
  bool _hover = false;
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() { _shimmer.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _hover ? -8.0 : 0.0),
          margin: const EdgeInsets.only(bottom: 0),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _hover ? AppColors.bgHover : AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hover ? widget.gradient.last.withOpacity(.5) : AppColors.border,
              width: 1.5,
            ),
            boxShadow: _hover ? [
              BoxShadow(
                color: widget.gradient.first.withOpacity(.25),
                blurRadius: 30, offset: const Offset(0, 8),
              ),
            ] : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // icon circle
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: widget.gradient,
                  ),
                  boxShadow: _hover ? [
                    BoxShadow(color: widget.gradient.first.withOpacity(.4), blurRadius: 16),
                  ] : [],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 22),
              ),

              const SizedBox(height: 16),

              // label
              Text(widget.label,
                  style: AppText.condensed(color: AppColors.textMuted, size: 10)),

              const SizedBox(height: 4),

              // value
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'BarlowCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: _hover ? AppColors.textPrimary : AppColors.textPrimary.withOpacity(.8),
                  letterSpacing: .3,
                ),
                child: Text(widget.value),
              ),

              const SizedBox(height: 4),

              Text(widget.sub,
                  style: AppText.body(color: AppColors.textDim, size: 12)),

              const SizedBox(height: 16),

              // tap to copy hint
              Row(children: [
                Expanded(child: Container(height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _hover
                          ? widget.gradient
                          : [AppColors.border, AppColors.border],
                    ),
                  ),
                )),
                const SizedBox(width: 8),
                AnimatedOpacity(
                  opacity: _hover ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Text('TAP TO COPY',
                      style: AppText.condensed(
                          color: widget.gradient.last, size: 9)),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}


