import 'dart:async';

import 'package:base_app/common/styles/app_theme.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      _Step(
        number: 1,
        title: l10n.howItWorksStep1Title,
        desc: l10n.howItWorksStep1Desc,
        icon: Icons.waving_hand_rounded,
        color: const Color(0xFF5C6BC0),
      ),
      _Step(
        number: 2,
        title: l10n.howItWorksStep2Title,
        desc: l10n.howItWorksStep2Desc,
        icon: Icons.category_rounded,
        color: AppColors.primary,
      ),
      _Step(
        number: 3,
        title: l10n.howItWorksStep3Title,
        desc: l10n.howItWorksStep3Desc,
        icon: Icons.folder_open_rounded,
        color: const Color(0xFF00897B),
      ),
      _Step(
        number: 4,
        title: l10n.howItWorksStep4Title,
        desc: l10n.howItWorksStep4Desc,
        icon: Icons.toggle_on_rounded,
        color: const Color(0xFF43A047),
      ),
      _Step(
        number: 5,
        title: l10n.howItWorksStep5Title,
        desc: l10n.howItWorksStep5Desc,
        icon: Icons.play_circle_rounded,
        color: const Color(0xFFE53935),
      ),
      _Step(
        number: 6,
        title: l10n.howItWorksStep6Title,
        desc: l10n.howItWorksStep6Desc,
        icon: Icons.bookmark_rounded,
        color: const Color(0xFF8E24AA),
      ),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          Text(
            l10n.howItWorksTitle,
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
              final isDesktop = constraints.maxWidth >= 700;
              return isDesktop
                  ? _DesktopSteps(steps: steps)
                  : _MobileSteps(steps: steps);
            },
          ),
        ],
      ),
    );
  }
}

class _Step {
  const _Step({
    required this.number,
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
  });

  final int number;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
}

class _DesktopSteps extends StatelessWidget {
  const _DesktopSteps({required this.steps});

  final List<_Step> steps;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < steps.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StaggeredStepCard(
                  delay: Duration(milliseconds: i * 80),
                  step: steps[i],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: i + 1 < steps.length
                    ? _StaggeredStepCard(
                        delay: Duration(milliseconds: (i + 1) * 80),
                        step: steps[i + 1],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < steps.length) rows.add(const SizedBox(height: 20));
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(children: rows),
    );
  }
}

class _MobileSteps extends StatelessWidget {
  const _MobileSteps({required this.steps});

  final List<_Step> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps
          .asMap()
          .entries
          .map(
            (e) => _StaggeredStepCard(
              delay: Duration(milliseconds: e.key * 60),
              step: e.value,
            ),
          )
          .toList(),
    );
  }
}

class _StaggeredStepCard extends StatefulWidget {
  const _StaggeredStepCard({required this.delay, required this.step});

  final Duration delay;
  final _Step step;

  @override
  State<_StaggeredStepCard> createState() => _StaggeredStepCardState();
}

class _StaggeredStepCardState extends State<_StaggeredStepCard>
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
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)),
        child: _StepCard(step: widget.step),
      ),
    );
  }
}

class _StepCard extends StatefulWidget {
  const _StepCard({required this.step});

  final _Step step;

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard>
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
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color.lerp(
                    const Color(0xFFE8EEF7),
                    widget.step.color.withValues(alpha: 0.4),
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
              child: child,
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number badge with icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.step.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.step.icon,
                    color: widget.step.color,
                    size: 26,
                  ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: widget.step.color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.step.number.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.step.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.step.desc,
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
