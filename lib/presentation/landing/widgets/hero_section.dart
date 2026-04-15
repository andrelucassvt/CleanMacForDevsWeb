import 'dart:async';

import 'package:base_app/common/styles/app_theme.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  static const String _appStoreUrl =
      'https://apps.apple.com/us/app/cleanmacfordevs/id6761320161';

  static Future<void> openAppStore() async {
    final uri = Uri.parse(_appStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _floatCtrl;

  late final Animation<double> _badgeFade;
  late final Animation<Offset> _badgeSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;
  late final Animation<double> _imageFade;
  late final Animation<Offset> _imageSlide;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _badgeFade = _fadeInterval(0, 0.35);
    _badgeSlide = _slideInterval(0, 0.35, const Offset(0, 0.6));
    _titleFade = _fadeInterval(0.1, 0.5);
    _titleSlide = _slideInterval(0.1, 0.5, const Offset(0, 0.5));
    _subtitleFade = _fadeInterval(0.25, 0.65);
    _subtitleSlide = _slideInterval(0.25, 0.65, const Offset(0, 0.4));
    _btnFade = _fadeInterval(0.4, 0.75);
    _btnSlide = _slideInterval(0.4, 0.75, const Offset(0, 0.4));
    _imageFade = _fadeInterval(0.15, 0.6);
    _imageSlide = _slideInterval(0.15, 0.6, const Offset(0.08, 0));

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    unawaited(_floatCtrl.repeat(reverse: true));

    _float = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    unawaited(_enterCtrl.forward());
  }

  Animation<double> _fadeInterval(double start, double end) => CurvedAnimation(
    parent: _enterCtrl,
    curve: Interval(start, end, curve: Curves.easeOut),
  );

  Animation<Offset> _slideInterval(
    double start,
    double end,
    Offset from,
  ) => Tween<Offset>(begin: from, end: Offset.zero).animate(
    CurvedAnimation(
      parent: _enterCtrl,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ),
  );

  @override
  void dispose() {
    _enterCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark,
                AppColors.primary,
                Color(0xFF1976D2),
              ],
            ),
          ),
          child: isDesktop
              ? _DesktopHero(l10n: l10n, s: this)
              : _MobileHero(l10n: l10n, s: this),
        );
      },
    );
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero({required this.l10n, required this.s});

  final AppLocalizations l10n;
  final _HeroSectionState s;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Row(
        children: [
          Expanded(
            child: _HeroText(l10n: l10n, s: s),
          ),
          const SizedBox(width: 60),
          Expanded(
            child: FadeTransition(
              opacity: s._imageFade,
              child: SlideTransition(
                position: s._imageSlide,
                child: AnimatedBuilder(
                  animation: s._float,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, s._float.value),
                    child: child,
                  ),
                  child: const _HeroImage(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero({required this.l10n, required this.s});

  final AppLocalizations l10n;
  final _HeroSectionState s;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: Column(
        children: [
          _HeroText(l10n: l10n, s: s),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: s._imageFade,
            child: SlideTransition(
              position: s._imageSlide,
              child: AnimatedBuilder(
                animation: s._float,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, s._float.value * 0.6),
                  child: child,
                ),
                child: const _HeroImage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.l10n, required this.s});

  final AppLocalizations l10n;
  final _HeroSectionState s;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: s._badgeFade,
          child: SlideTransition(
            position: s._badgeSlide,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'macOS App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.heroAppStoreBadge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FadeTransition(
          opacity: s._titleFade,
          child: SlideTransition(
            position: s._titleSlide,
            child: Text(
              l10n.heroTitle,
              style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: s._subtitleFade,
          child: SlideTransition(
            position: s._subtitleSlide,
            child: Text(
              l10n.heroSubtitle,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        FadeTransition(
          opacity: s._btnFade,
          child: SlideTransition(
            position: s._btnSlide,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FeatureBullet(text: l10n.featureCleanAll),
                _FeatureBullet(text: l10n.featureSpacePreview),
                _FeatureBullet(text: l10n.featureSupportedTechs),
                const SizedBox(height: 24),
                _DownloadButton(label: l10n.downloadButton),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/image1.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  const _FeatureBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 13),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadButton extends StatefulWidget {
  const _DownloadButton({required this.label});

  final String label;

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverCtrl;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 1,
      upperBound: 1.05,
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovering = true);
        unawaited(_hoverCtrl.forward());
      },
      onExit: (_) {
        setState(() => _hovering = false);
        unawaited(_hoverCtrl.reverse());
      },
      child: ScaleTransition(
        scale: _hoverCtrl,
        child: ElevatedButton.icon(
          onPressed: HeroSection.openAppStore,
          icon: const Icon(Icons.apple, size: 22),
          label: Text(
            widget.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: _hovering ? 10 : 0,
            shadowColor: Colors.black.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}
