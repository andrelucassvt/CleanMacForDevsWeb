import 'dart:async';

import 'package:base_app/common/styles/app_theme.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ScreenshotsSection extends StatefulWidget {
  const ScreenshotsSection({super.key});

  @override
  State<ScreenshotsSection> createState() => _ScreenshotsSectionState();
}

class _ScreenshotInfo {
  const _ScreenshotInfo({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  final String imagePath;
  final String title;
  final String description;
}

class _ScreenshotsSectionState extends State<ScreenshotsSection> {
  int _selectedIndex = 0;
  Timer? _autoTimer;
  bool _userInteracted = false;

  // Order: welcome → general analysis → flutter → xcode
  //        → confirmation (image5) → nodejs (image4)
  late List<_ScreenshotInfo> _screenshots;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = context.l10n;
    _screenshots = [
      _ScreenshotInfo(
        imagePath: 'assets/images/image1.png',
        title: l10n.screenshot1Title,
        description: l10n.screenshot1Desc,
      ),
      _ScreenshotInfo(
        imagePath: 'assets/images/image6.png',
        title: l10n.screenshot6Title,
        description: l10n.screenshot6Desc,
      ),
      _ScreenshotInfo(
        imagePath: 'assets/images/image2.png',
        title: l10n.screenshot2Title,
        description: l10n.screenshot2Desc,
      ),
      _ScreenshotInfo(
        imagePath: 'assets/images/image3.png',
        title: l10n.screenshot3Title,
        description: l10n.screenshot3Desc,
      ),
      _ScreenshotInfo(
        imagePath: 'assets/images/image5.png',
        title: l10n.screenshot4Title,
        description: l10n.screenshot4Desc,
      ),
      _ScreenshotInfo(
        imagePath: 'assets/images/image4.png',
        title: l10n.screenshot5Title,
        description: l10n.screenshot5Desc,
      ),
    ];
    // _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!_userInteracted && mounted) {
        setState(
          () => _selectedIndex = (_selectedIndex + 1) % _screenshots.length,
        );
      }
    });
  }

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _userInteracted = true;
    });
    // Resume auto-advance after 8s of inactivity
    _autoTimer?.cancel();
    _autoTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _userInteracted = false);
        _startAutoAdvance();
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_screenshots.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: const Color(0xFFF0F5FF),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          Text(
            context.l10n.screenshotsTitle,
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
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 700) {
                return _DesktopShowcase(
                  screenshots: _screenshots,
                  selectedIndex: _selectedIndex,
                  onSelect: _selectIndex,
                );
              }
              return _MobileShowcase(
                screenshots: _screenshots,
                selectedIndex: _selectedIndex,
                onSelect: _selectIndex,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Desktop ─────────────────────────────────────────────────────────────────

class _DesktopShowcase extends StatelessWidget {
  const _DesktopShowcase({
    required this.screenshots,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_ScreenshotInfo> screenshots;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step list
          SizedBox(
            width: 280,
            child: Column(
              children: screenshots.asMap().entries.map((e) {
                return _StepItem(
                  index: e.key,
                  info: e.value,
                  isSelected: e.key == selectedIndex,
                  onTap: () => onSelect(e.key),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 40),
          // Screenshot
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                final slide =
                    Tween<Offset>(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    );
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              child: _ScreenshotCard(
                key: ValueKey(selectedIndex),
                imagePath: screenshots[selectedIndex].imagePath,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.index,
    required this.info,
    required this.isSelected,
    required this.onTap,
  });

  final int index;
  final _ScreenshotInfo info;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.07)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : const Color(0xFFE8EEF7),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: isSelected
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              info.description,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
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

// ─── Mobile ──────────────────────────────────────────────────────────────────

class _MobileShowcase extends StatefulWidget {
  const _MobileShowcase({
    required this.screenshots,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_ScreenshotInfo> screenshots;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  State<_MobileShowcase> createState() => _MobileShowcaseState();
}

class _MobileShowcaseState extends State<_MobileShowcase> {
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(_MobileShowcase old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex && _pageCtrl.hasClients) {
      unawaited(
        _pageCtrl.animateToPage(
          widget.selectedIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.screenshots[widget.selectedIndex];
    return Column(
      children: [
        // Screenshot carousel
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageCtrl,
            onPageChanged: widget.onSelect,
            itemCount: widget.screenshots.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _ScreenshotCard(
                imagePath: widget.screenshots[index].imagePath,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.screenshots.length,
            (i) => GestureDetector(
              onTap: () => widget.onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == widget.selectedIndex ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == widget.selectedIndex
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Title + description for current slide
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Padding(
            key: ValueKey(widget.selectedIndex),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(
                  selected.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  selected.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Shared ──────────────────────────────────────────────────────────────────

class _ScreenshotCard extends StatelessWidget {
  const _ScreenshotCard({required this.imagePath, super.key});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}
