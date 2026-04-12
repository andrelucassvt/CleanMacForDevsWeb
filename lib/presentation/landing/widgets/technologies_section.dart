import 'dart:async';

import 'package:base_app/common/styles/app_theme.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TechnologiesSection extends StatelessWidget {
  const TechnologiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final techs = [
      _TechItem(
        name: l10n.flutterName,
        icon: Icons.flutter_dash,
        color: const Color(0xFF54C5F8),
      ),
      _TechItem(
        name: l10n.xcodeName,
        icon: Icons.code,
        color: const Color(0xFF147EFB),
      ),
      _TechItem(
        name: l10n.swiftName,
        icon: Icons.rocket_launch,
        color: const Color(0xFFF05138),
      ),
      _TechItem(
        name: l10n.nodejsName,
        icon: Icons.hub,
        color: const Color(0xFF68A063),
      ),
      _TechItem(
        name: l10n.pythonName,
        icon: Icons.terminal,
        color: const Color(0xFF3572A5),
      ),
      _TechItem(
        name: l10n.rustName,
        icon: Icons.memory,
        color: const Color(0xFFDE4A00),
      ),
      _TechItem(
        name: l10n.androidName,
        icon: Icons.android,
        color: const Color(0xFF3DDC84),
      ),
      _TechItem(
        name: l10n.reactNativeName,
        icon: Icons.phone_android,
        color: const Color(0xFF61DAFB),
      ),
      _TechItem(
        name: l10n.reactName,
        icon: Icons.web,
        color: const Color(0xFF61DAFB),
      ),
      _TechItem(
        name: l10n.dockerName,
        icon: Icons.inventory_2,
        color: const Color(0xFF2496ED),
      ),
      _TechItem(
        name: l10n.gradleCacheName,
        icon: Icons.storage,
        color: const Color(0xFF02A88F),
      ),
      _TechItem(
        name: l10n.npmGlobalName,
        icon: Icons.public,
        color: const Color(0xFFCB3837),
      ),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          Text(
            l10n.featuresTitle,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 600
                  ? 3
                  : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: techs
                    .asMap()
                    .entries
                    .map(
                      (e) => _StaggeredCard(
                        delay: Duration(milliseconds: e.key * 60),
                        child: _TechCard(item: e.value),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TechItem {
  const _TechItem({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}

/// Fades + scales in a child after [delay].
class _StaggeredCard extends StatefulWidget {
  const _StaggeredCard({required this.delay, required this.child});

  final Duration delay;
  final Widget child;

  @override
  State<_StaggeredCard> createState() => _StaggeredCardState();
}

class _StaggeredCardState extends State<_StaggeredCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    Future.delayed(widget.delay, () {
      if (mounted) unawaited(_ctrl.forward());
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1).animate(
          CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
        ),
        child: widget.child,
      ),
    );
  }
}

class _TechCard extends StatefulWidget {
  const _TechCard({required this.item});

  final _TechItem item;

  @override
  State<_TechCard> createState() => _TechCardState();
}

class _TechCardState extends State<_TechCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverCtrl;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
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
      onEnter: (_) => unawaited(_hoverCtrl.forward()),
      onExit: (_) => unawaited(_hoverCtrl.reverse()),
      child: AnimatedBuilder(
        animation: _hoverCtrl,
        builder: (context, child) {
          final t = _hoverCtrl.value;
          return Transform.scale(
            scale: 1 + t * 0.04,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color.lerp(
                    const Color(0xFFE8EEF7),
                    widget.item.color.withValues(alpha: 0.5),
                    t,
                  )!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05 + t * 0.1),
                    blurRadius: 12 + t * 16,
                    offset: Offset(0, 4 + t * 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: widget.item.color.withValues(alpha: 0.1 + t * 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.item.icon,
                      color: widget.item.color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
