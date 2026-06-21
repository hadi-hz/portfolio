import 'package:flutter/material.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';

class NavBar extends StatelessWidget {
  final bool isScrolled;
  final Function(GlobalKey) onNav;
  final GlobalKey heroKey, aboutKey, skillsKey, projectsKey, experienceKey, contactKey;

  const NavBar({super.key, required this.isScrolled, required this.onNav,
    required this.heroKey, required this.aboutKey, required this.skillsKey,
    required this.projectsKey, required this.experienceKey, required this.contactKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isScrolled ? AppColors.bg.withOpacity(.9) : Colors.transparent,
        border: isScrolled ? const Border(bottom: BorderSide(color: AppColors.border)) : null,
        boxShadow: isScrolled ? [BoxShadow(color: AppColors.accentGlow.withOpacity(.25), blurRadius: 20)] : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.accentLight, AppColors.cyan],
          ).createShader(b),
          child: const Text('hh.', style: TextStyle(
            fontFamily: 'BarlowCondensed', fontWeight: FontWeight.w900,
            fontSize: 22, color: Colors.white, letterSpacing: -.5,
          )),
        ),
        const Spacer(),
        if (!isMobile) ...[
          _Link('About',      () => onNav(aboutKey)),
          _Link('Skills',     () => onNav(skillsKey)),
          _Link('Projects',   () => onNav(projectsKey)),
          _Link('Experience', () => onNav(experienceKey)),
          _Link('Contact',    () => onNav(contactKey)),
          const SizedBox(width: 24),
        ],
        _HireBtn(onTap: () => onNav(contactKey)),
      ]),
    );
  }
}

class _Link extends StatefulWidget {
  final String label; final VoidCallback onTap;
  const _Link(this.label, this.onTap);
  @override State<_Link> createState() => _LinkState();
}
class _LinkState extends State<_Link> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: AppText.condensed(color: _h ? AppColors.accentLight : AppColors.textMuted, size: 11),
          child: Text(widget.label.toUpperCase()),
        ),
      ),
    ),
  );
}

class _HireBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _HireBtn({required this.onTap});
  @override State<_HireBtn> createState() => _HireBtnState();
}
class _HireBtnState extends State<_HireBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: _h ? const LinearGradient(colors: [AppColors.accent, AppColors.cyan]) : null,
          color: _h ? null : Colors.transparent,
          border: Border.all(color: _h ? Colors.transparent : AppColors.border),
          borderRadius: BorderRadius.circular(99),
          boxShadow: _h ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 16)] : null,
        ),
        child: Text('HIRE ME',
            style: AppText.condensed(color: _h ? Colors.white : AppColors.textMuted, size: 11)),
      ),
    ),
  );
}
