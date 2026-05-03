import 'dart:async';

import 'package:base_app/common/styles/app_theme.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class WhatIsRemovedSection extends StatelessWidget {
  const WhatIsRemovedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      _CleanItem(
        name: l10n.flutterName,
        desc: l10n.flutterDesc,
        icon: Icons.flutter_dash,
        color: const Color(0xFF54C5F8),
      ),
      _CleanItem(
        name: l10n.xcodeName,
        desc: l10n.xcodeDesc,
        icon: Icons.code,
        color: const Color(0xFF147EFB),
      ),
      _CleanItem(
        name: l10n.swiftName,
        desc: l10n.swiftDesc,
        icon: Icons.rocket_launch,
        color: const Color(0xFFF05138),
      ),
      _CleanItem(
        name: l10n.nodejsName,
        desc: l10n.nodejsDesc,
        icon: Icons.hub,
        color: const Color(0xFF68A063),
      ),
      _CleanItem(
        name: l10n.pythonName,
        desc: l10n.pythonDesc,
        icon: Icons.terminal,
        color: const Color(0xFF3572A5),
      ),
      _CleanItem(
        name: l10n.rustName,
        desc: l10n.rustDesc,
        icon: Icons.memory,
        color: const Color(0xFFDE4A00),
      ),
      _CleanItem(
        name: l10n.androidName,
        desc: l10n.androidDesc,
        icon: Icons.android,
        color: const Color(0xFF3DDC84),
      ),
      _CleanItem(
        name: l10n.reactNativeName,
        desc: l10n.reactNativeDesc,
        icon: Icons.phone_android,
        color: const Color(0xFF61DAFB),
      ),
      _CleanItem(
        name: l10n.reactName,
        desc: l10n.reactDesc,
        icon: Icons.web,
        color: const Color(0xFF61DAFB),
      ),
      _CleanItem(
        name: l10n.dockerName,
        desc: l10n.dockerDesc,
        icon: Icons.inventory_2,
        color: const Color(0xFF2496ED),
      ),
      _CleanItem(
        name: l10n.gradleCacheName,
        desc: l10n.gradleCacheDesc,
        icon: Icons.storage,
        color: const Color(0xFF02A88F),
      ),
      _CleanItem(
        name: l10n.npmGlobalName,
        desc: l10n.npmGlobalDesc,
        icon: Icons.public,
        color: const Color(0xFFCB3837),
      ),
      _CleanItem(
        name: l10n.ollamaName,
        desc: l10n.ollamaDesc,
        icon: Icons.smart_toy_rounded,
        color: const Color(0xFF7C3AED),
      ),
      _CleanItem(
        name: l10n.javaMavenName,
        desc: l10n.javaMavenDesc,
        icon: Icons.coffee_rounded,
        color: const Color(0xFFED8B00),
      ),
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          Text(
            l10n.whatIsRemovedTitle,
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
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: items
                    .asMap()
                    .entries
                    .map(
                      (e) => SizedBox(
                        width: 340,
                        child: _StaggeredCleanCard(
                          delay: Duration(milliseconds: e.key * 50),
                          item: e.value,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CleanItem {
  const _CleanItem({
    required this.name,
    required this.desc,
    required this.icon,
    required this.color,
  });

  final String name;
  final String desc;
  final IconData icon;
  final Color color;
}

/// Wrapper that fades + slides a [_CleanCard] in after [delay].
class _StaggeredCleanCard extends StatefulWidget {
  const _StaggeredCleanCard({required this.delay, required this.item});

  final Duration delay;
  final _CleanItem item;

  @override
  State<_StaggeredCleanCard> createState() => _StaggeredCleanCardState();
}

class _StaggeredCleanCardState extends State<_StaggeredCleanCard>
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
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.05, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)),
        child: _CleanCard(item: widget.item),
      ),
    );
  }
}

class _CleanCard extends StatefulWidget {
  const _CleanCard({required this.item});

  final _CleanItem item;

  @override
  State<_CleanCard> createState() => _CleanCardState();
}

class _CleanCardState extends State<_CleanCard>
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
          return Transform.translate(
            offset: Offset(0, -4 * t),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color.lerp(
                    const Color(0xFFE8EEF7),
                    widget.item.color.withValues(alpha: 0.4),
                    t,
                  )!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04 + t * 0.08),
                    blurRadius: 12 + t * 12,
                    offset: Offset(0, 4 + t * 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 4,
                        color: Color.lerp(
                          widget.item.color.withValues(alpha: 0.3),
                          widget.item.color,
                          t,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.item.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.item.icon,
                color: widget.item.color,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
