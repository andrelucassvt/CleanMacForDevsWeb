import 'dart:async';

import 'package:base_app/common/styles/app_theme.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class RobotPetSection extends StatefulWidget {
  const RobotPetSection({super.key});

  @override
  State<RobotPetSection> createState() => _RobotPetSectionState();
}

class _RobotPetSectionState extends State<RobotPetSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    unawaited(_floatCtrl.repeat(reverse: true));
    _float = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3F0FF), Color(0xFFEEF2FF)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          if (isDesktop) {
            return _DesktopContent(l10n: l10n, float: _float);
          }
          return _MobileContent(l10n: l10n, float: _float);
        },
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent({required this.l10n, required this.float});

  final AppLocalizations l10n;
  final Animation<double> float;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Row(
          children: [
            Expanded(child: _RobotImage(float: float)),
            const SizedBox(width: 72),
            Expanded(child: _TextContent(l10n: l10n)),
          ],
        ),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent({required this.l10n, required this.float});

  final AppLocalizations l10n;
  final Animation<double> float;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TextContent(l10n: l10n),
        const SizedBox(height: 48),
        SizedBox(height: 200, child: _RobotImage(float: float)),
      ],
    );
  }
}

class _RobotImage extends StatelessWidget {
  const _RobotImage({required this.float});

  final Animation<double> float;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF7C3AED).withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: float,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, float.value),
              child: child,
            ),
            child: Image.asset(
              'assets/images/robot-promo.png',
              width: 200,
              height: 200,
              filterQuality: FilterQuality.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🤖', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                l10n.robotPetBadge,
                style: const TextStyle(
                  color: Color(0xFF7C3AED),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.robotPetTitle,
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.robotPetSubtitle,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        _PetFeatureBullet(
          icon: Icons.celebration_rounded,
          text: l10n.robotPetFeature1,
        ),
        const SizedBox(height: 12),
        _PetFeatureBullet(
          icon: Icons.toggle_on_rounded,
          text: l10n.robotPetFeature2,
        ),
        const SizedBox(height: 12),
        _PetFeatureBullet(
          icon: Icons.auto_awesome_rounded,
          text: l10n.robotPetFeature3,
        ),
      ],
    );
  }
}

class _PetFeatureBullet extends StatelessWidget {
  const _PetFeatureBullet({required this.icon, required this.text});

  final IconData icon;
  final String text;

  static const _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _purple, size: 18),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
