import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hadi_portfolio/core/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  VideoPlayerController? _videoController;
  bool _initialized = false;
  bool _autoPlayDone = false; // آیا پخش اول تموم شده؟

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.asset('assets/videos/intro.mp4');
      await controller.initialize();
      if (!mounted) { controller.dispose(); return; }

      setState(() {
        _videoController = controller;
        _initialized = true;
      });

      // volume=0 → مرورگر اجازه autoplay میده
      await controller.setVolume(0.0);
      await controller.setLooping(false);
      await controller.play();

      controller.addListener(() {
        if (!mounted) return;
        final pos      = controller.value.position;
        final duration = controller.value.duration;
        if (!_autoPlayDone &&
            duration.inMilliseconds > 0 &&
            pos.inMilliseconds >= duration.inMilliseconds - 150) {
          setState(() => _autoPlayDone = true);
          controller.pause();
          controller.seekTo(Duration.zero);
        }
      });
    } catch (e) {
      debugPrint('Video init error: $e');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

// کاربر Play Reel زد — با صدا از اول
  Future<void> _playReel() async {
    final ctrl = _videoController;
    if (ctrl == null || !_initialized) return;
    setState(() => _autoPlayDone = false);
    await ctrl.setVolume(1.0);
    await ctrl.seekTo(Duration.zero);
    await ctrl.play();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(fit: StackFit.expand, children: [
        // ── ۱. ویدئو — نسبت اصلی حفظ میشه، از بالا شروع میشه ──
        if (_initialized && _videoController != null)
          _FullscreenVideo(controller: _videoController!)
        else
          _VideoPlaceholder(),

        // ── ۲. overlay چپ برای خوانایی text ──
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Colors.black.withOpacity(0.05),
                Colors.black.withOpacity(0.55),
              ],
            ),
          ),
        ),

        // ── ۳. fade پایین به bg ──
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: size.height * .30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.bg, Colors.transparent],
              ),
            ),
          ),
        ),

        // ── ۴. fade بالا برای nav ──
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(.4), Colors.transparent],
              ),
            ),
          ),
        ),

        // ── ۵. glow orbs ──
        Positioned(
          top: -80,
          right: -80,
          child: IgnorePointer(
              child:
                  _GlowOrb(size: 400, color: AppColors.accent, opacity: .07)),
        ),
        Positioned(
          bottom: 100,
          left: -60,
          child: IgnorePointer(
              child: _GlowOrb(size: 300, color: AppColors.cyan, opacity: .04)),
        ),

// ── ۶. orbit ring ──
        Positioned(
          top: size.height * .05,
          right: isMobile ? -80 : 40,
          child: IgnorePointer(child: _OrbitRing(size: isMobile ? 200 : 280)),
        ),

        // ── ۷. content پایین-چپ ──
        Positioned(
          left: isMobile ? 20 : 56,
          bottom: isMobile ? 44 : 64,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.4),
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text("Hi, I'm",
                    style: AppText.condensed(
                        color: AppColors.accentLight, size: 20)),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: .3, end: 0),
              const SizedBox(height: 12),
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [Colors.white, AppColors.accentLight],
                ).createShader(b),
                child: Text(
                  'Hadi\nHazari',
                  style: AppText.display(
                    color: Colors.white,
                    size: isMobile ? 52 : 76,
                  ),
                ),
              )
                  .animate(delay: 150.ms)
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: .2, end: 0),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    'Flutter Developer passionate about building\nmodern, beautiful, and functional apps.',
                    style: AppText.body(color: Colors.white70, size: 14),
                  ),
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 600.ms),
              // const SizedBox(height: 28),
              // Row(children: [
              //   _HeroBtn(label: 'View My Work', filled: true),
              //   const SizedBox(width: 12),
              //   _HeroBtn(label: 'Contact Me', filled: false),
              // ]).animate(delay: 450.ms).fadeIn(duration: 600.ms),
            ],
          ),
        ),

        // ── ۸. Play Reel پایین-راست ──
        Positioned(
          right: isMobile ? 20 : 56,
          bottom: isMobile ? 44 : 64,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _PlayReel(onTap: _playReel),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.35),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('PLAY REEL',
                  style: AppText.condensed(color: Colors.white60, size: 9)),
            ),
          ]).animate(delay: 700.ms).fadeIn(duration: 600.ms),
        ),

        // ── ۹. scroll indicator ──
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: Container(
                width: 1,
                height: 36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.accentLight, Colors.transparent],
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fadeIn(duration: 900.ms)
                  .then()
                  .fadeOut(duration: 900.ms),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Fullscreen Video ──────────────────────────────────────────────
// نسبت ویدئو حفظ میشه و از بالا-وسط align میشه
class _FullscreenVideo extends StatelessWidget {
  final VideoPlayerController controller;

  const _FullscreenVideo({required this.controller});

  @override
  Widget build(BuildContext context) {
    final videoSize = controller.value.size;
    final screenSize = MediaQuery.of(context).size;

    if (videoSize.isEmpty) return const SizedBox.shrink();

    // نسبت ویدئو
    final videoRatio = videoSize.width / videoSize.height;
    final screenRatio = screenSize.width / screenSize.height;

    double w, h;
    if (videoRatio > screenRatio) {
      // ویدئو پهن‌تره — ارتفاع رو fix کن
      h = screenSize.height;
      w = h * videoRatio;
    } else {
      // ویدئو باریک‌تره — عرض رو fix کن
      w = screenSize.width;
      h = w / videoRatio;
    }

    // از بالا-وسط — سر کاملاً دیده میشه
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: w,
        height: h,
        child: VideoPlayer(controller),
      ),
    );
  }
}

// ── Video Placeholder ─────────────────────────────────────────────
class _VideoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bg, Color(0xFF0D0B2E), AppColors.bg],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
              color: AppColors.accentLight, strokeWidth: 1.5),
        ),
      );
}

// ── Glow Orb ─────────────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final double size, opacity;
  final Color color;

  const _GlowOrb(
      {required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
              colors: [color.withOpacity(opacity), Colors.transparent]),
        ),
      );
}

// ── Orbit Ring ────────────────────────────────────────────────────
class _OrbitRing extends StatefulWidget {
  final double size;

  const _OrbitRing({required this.size});

  @override
  State<_OrbitRing> createState() => _OrbitRingState();
}

class _OrbitRingState extends State<_OrbitRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Transform.rotate(
          angle: _c.value * 6.28,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.accentLight.withOpacity(.08), width: 1),
            ),
            child: Stack(children: [
              Positioned(
                top: 0,
                left: widget.size / 2 - 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cyan,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.cyan.withOpacity(.9), blurRadius: 12)
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
}

// ── Hero Button ───────────────────────────────────────────────────
class _HeroBtn extends StatefulWidget {
  final String label;
  final bool filled;

  const _HeroBtn({required this.label, required this.filled});

  @override
  State<_HeroBtn> createState() => _HeroBtnState();
}

class _HeroBtnState extends State<_HeroBtn> {
  bool _h = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.filled
                ? LinearGradient(
                    colors: _h
                        ? [AppColors.accent, AppColors.cyan]
                        : [AppColors.accent, AppColors.accent],
                  )
                : null,
            color: widget.filled ? null : Colors.black.withOpacity(.35),
            border: Border.all(
              color: widget.filled
                  ? Colors.transparent
                  : (_h ? AppColors.accentLight : Colors.white38),
            ),
            borderRadius: BorderRadius.circular(99),
            boxShadow: widget.filled
                ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 20)]
                : null,
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: AppText.condensed(
              color: widget.filled
                  ? Colors.white
                  : (_h ? AppColors.accentLight : Colors.white70),
              size: 11,
            ),
          ),
        ),
      );
}

// ── Play Reel ─────────────────────────────────────────────────────
class _PlayReel extends StatefulWidget {
  final VoidCallback onTap;

  const _PlayReel({required this.onTap});

  @override
  State<_PlayReel> createState() => _PlayReelState();
}

class _PlayReelState extends State<_PlayReel>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, child) => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 66 + _c.value * 14,
                height: 66 + _c.value * 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(.08 + _c.value * .1),
                    width: 1,
                  ),
                ),
              ),
              child!,
            ],
          ),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(.45),
              border: Border.all(color: Colors.white38, width: 1.5),
            ),
            child: const Center(
              child:
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
            ),
          ),
        ),
      );
}
