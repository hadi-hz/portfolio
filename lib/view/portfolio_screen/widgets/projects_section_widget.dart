import 'package:flutter/material.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});
  @override State<ProjectsSection> createState() => _ProjectsSectionState();
}
class _ProjectsSectionState extends State<ProjectsSection> {
  bool _visible = false;
  static const _projects = [
    ('01','Mobile App','Freelancer — WHO',          'App for the World Health Organization — Clean Architecture, GetX, Firebase, Google Maps.',['Flutter','GetX','Firebase','Google Maps']),
    ('02','Web App',   'Taraz — ERP System',        'Enterprise ERP for the web — Clean Architecture, Freezed, GetIt, Dio.',                  ['Flutter Web','Clean Arch','GetIt','Dio']),
    ('03','Mobile App','CRM — Restaurant Mgmt',     'MVVM + Provider, native POS via MethodChannel, multilingual animations.',                ['MVVM','Provider','MethodChannel']),
    ('04','Mobile App','Kara — Retail Distribution','Real-time tracking, Flutter Map, Geolocator, Kotlin via MethodChannel.',                  ['MVVM','GetX','Flutter Map','Kotlin']),
    ('05','Mobile App','Dejban — Attendance',        'Location-based check-in, Firebase notifications, Dartz error handling.',                 ['GetX','Dio','Firebase','Dartz']),
    ('06','Mobile App','Pulban — Personal Finance',  'MVC + GetX, Hive persistence, Secure Storage, responsive Material UI.',                 ['MVC','GetX','Hive']),
  ];
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return VisibilityDetector(
      key: const Key('projects'),
      onVisibilityChanged: (i) { if (i.visibleFraction > .05 && !_visible) setState(() => _visible = true); },
      child: Container(
        color: AppColors.bg,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80, vertical: 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('WORK', style: AppText.condensed(color: AppColors.cyan, size: 11)),
          const SizedBox(height: 10),
          AppText.gradient('Projects', AppText.heading(size: 42)),
          const SizedBox(height: 48),
          ..._projects.asMap().entries.map((e) => _ProjectRow(
            num: e.value.$1, type: e.value.$2, name: e.value.$3,
            desc: e.value.$4, tags: e.value.$5,
            visible: _visible, delay: e.key * 80, isMobile: isMobile,
          )),
        ]),
      ),
    );
  }
}

class _ProjectRow extends StatefulWidget {
  final String num, type, name, desc;
  final List<String> tags;
  final bool visible, isMobile;
  final int delay;
  const _ProjectRow({required this.num, required this.type, required this.name,
    required this.desc, required this.tags, required this.visible,
    required this.delay, required this.isMobile});
  @override State<_ProjectRow> createState() => _ProjectRowState();
}
class _ProjectRowState extends State<_ProjectRow> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(left: _h ? 16 : 0, top: 24, bottom: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
        color: _h ? AppColors.bgCard.withOpacity(.5) : Colors.transparent,
        borderRadius: _h ? BorderRadius.circular(8) : null,
      ),
      child: Row(children: [
        SizedBox(width: 64,
            child: Text(widget.num, style: AppText.heading(
                color: _h ? AppColors.accentLight : AppColors.textDim, size: 32))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.type, style: AppText.condensed(color: AppColors.cyan, size: 9)),
          const SizedBox(height: 4),
          Text(widget.name, style: AppText.heading(size: widget.isMobile ? 17 : 21)),
          const SizedBox(height: 6),
          Text(widget.desc, style: AppText.body(size: 13)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 4,
              children: widget.tags.map((t) => AppTag(t)).toList()),
        ])),
        // if (!widget.isMobile) ...[
        //   const SizedBox(width: 24),
        //   AnimatedContainer(
        //     duration: const Duration(milliseconds: 200),
        //     width: 40, height: 40,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       gradient: _h ? const LinearGradient(colors: [AppColors.accent, AppColors.cyan]) : null,
        //       border: Border.all(color: _h ? Colors.transparent : AppColors.border),
        //       boxShadow: _h ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 16)] : null,
        //     ),
        //     child: Icon(Icons.arrow_outward_rounded, size: 16,
        //         color: _h ? Colors.white : AppColors.textMuted),
        //   ),
        // ],
      ]),
    ),
  );
}
