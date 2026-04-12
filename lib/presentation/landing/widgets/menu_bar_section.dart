import 'dart:async';

import 'package:base_app/common/styles/app_theme.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class MenuBarSection extends StatelessWidget {
  const MenuBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stats = [
      _Stat(
        label: l10n.menuBarRam,
        desc: l10n.menuBarRamDesc,
        icon: Icons.memory_rounded,
        color: const Color(0xFF42A5F5),
      ),
      _Stat(
        label: l10n.menuBarStorage,
        desc: l10n.menuBarStorageDesc,
        icon: Icons.storage_rounded,
        color: const Color(0xFF66BB6A),
      ),
      _Stat(
        label: l10n.menuBarCpu,
        desc: l10n.menuBarCpuDesc,
        icon: Icons.speed_rounded,
        color: const Color(0xFFEF5350),
      ),
      _Stat(
        label: l10n.menuBarBattery,
        desc: l10n.menuBarBatteryDesc,
        icon: Icons.battery_charging_full_rounded,
        color: const Color(0xFFFFCA28),
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            Color(0xFF1565C0),
            Color(0xFF1976D2),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          // Menu bar mockup icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'RAM 8.2 GB  SSD 128 GB  CPU 12%  ▸ 94%',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.menuBarTitle,
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              l10n.menuBarSubtitle,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 700 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: stats
                    .asMap()
                    .entries
                    .map(
                      (e) => _StaggeredStatCard(
                        delay: Duration(milliseconds: e.key * 80),
                        stat: e.value,
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

class _Stat {
  const _Stat({
    required this.label,
    required this.desc,
    required this.icon,
    required this.color,
  });

  final String label;
  final String desc;
  final IconData icon;
  final Color color;
}

class _StaggeredStatCard extends StatefulWidget {
  const _StaggeredStatCard({required this.delay, required this.stat});

  final Duration delay;
  final _Stat stat;

  @override
  State<_StaggeredStatCard> createState() => _StaggeredStatCardState();
}

class _StaggeredStatCardState extends State<_StaggeredStatCard>
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
        child: _StatCard(stat: widget.stat),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  const _StatCard({required this.stat});

  final _Stat stat;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08 + t * 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15 + t * 0.15),
                ),
              ),
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.stat.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.stat.icon,
                color: widget.stat.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.stat.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.stat.desc,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 12,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
