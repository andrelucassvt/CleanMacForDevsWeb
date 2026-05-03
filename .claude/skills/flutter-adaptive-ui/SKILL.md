---
name: flutter-adaptive-ui
description: Build adaptive and responsive Flutter UIs that work beautifully across all platforms and screen sizes. Use when creating Flutter apps that need to adapt layouts based on screen size, support multiple platforms including mobile tablet desktop and web, handle different input devices like touch mouse and keyboard, implement responsive navigation patterns, optimize for large screens and foldables, or use Capability and Policy patterns for platform-specific behavior.
---

# Flutter Adaptive UI

## Overview

Create Flutter applications that adapt gracefully to any screen size, platform, or input device. This skill provides comprehensive guidance for building responsive layouts that scale from mobile phones to large desktop displays while maintaining excellent user experience across touch, mouse, and keyboard interactions.

## Quick Reference

**Core Layout Rule:** Constraints go down. Sizes go up. Parent sets position.

**3-Step Adaptive Approach:**
1. **Abstract** - Extract common data from widgets
2. **Measure** - Determine available space (MediaQuery/LayoutBuilder)
3. **Branch** - Select appropriate UI based on breakpoints

**Key Breakpoints:**
* Compact (Mobile): width < 600
* Medium (Tablet): 600 <= width < 840  
* Expanded (Desktop): width >= 840

## Regras de Arquitetura do Projeto

Antes de aplicar qualquer padrão adaptativo, siga as regras obrigatórias da arquitetura:

- **NUNCA** crie `Widget _buildXxx()` nem classes privadas de widget dentro da View — extraia para `widgets/` (reutilizável) ou `content/` (auxiliar específico da View)
- **SEMPRE** envolva o conteúdo principal com `SafeArea`
- **SEMPRE** use imports absolutos: `package:base_app/...` — nunca relativos
- **SEMPRE** use `context.l10n.<chave>` para textos visíveis — nunca strings hardcoded
- Widgets adaptativos que variam por breakpoint são auxiliares de UI → vão em `content/`
- Widgets adaptativos reutilizáveis entre features → vão em `common/widgets/`

### Onde colocar os widgets adaptativos

| Tipo de widget | Pasta |
|---|---|
| Layout alternativo específico de uma View | `presentation/<feature>/content/` |
| Componente adaptativo reutilizável entre features | `common/widgets/` |
| Widget de navegação adaptativa (toda a app) | `common/widgets/` |

---

## Adaptive Workflow

Follow the 3-step approach to make your app adaptive.

### Step 1: Abstract

Identify widgets that need adaptability and extract common data. Common patterns:
- Navigation UI (switch between bottom bar and side rail)
- Dialogs (fullscreen on mobile, modal on desktop)
- Content lists (reflow from single to multi-column)

For navigation, create a shared `Destination` class with icon and label used by both `NavigationBar` and `NavigationRail`.

### Step 2: Measure

Choose the right measurement tool:

**MediaQuery.sizeOf(context)** - Use when you need app window size for top-level layout decisions
- Returns entire app window dimensions
- Better performance than `MediaQuery.of()` for size queries
- Rebuilds widget when window size changes

**LayoutBuilder** - Use when you need constraints for specific widget subtree
- Provides parent widget's constraints as `BoxConstraints`
- Local sizing information, not global window size
- Returns min/max width and height ranges

Example:
```dart
// For app-level decisions
final width = MediaQuery.sizeOf(context).width;

// For widget-specific constraints
// MobileProductLayout e DesktopProductLayout são classes públicas em content/ ou common/widgets/
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return const MobileProductLayout();
    }
    return const DesktopProductLayout();
  },
)
```

### Step 3: Branch

Apply breakpoints to select appropriate UI. Don't base decisions on device type - use window size instead.

Example breakpoints (from Material guidelines):

```dart
// lib/presentation/home/content/home_adaptive_layout.dart
// OU lib/common/widgets/adaptive_layout.dart (se for reutilizável)
import 'package:base_app/presentation/home/content/home_desktop_layout.dart';
import 'package:base_app/presentation/home/content/home_mobile_layout.dart';
import 'package:base_app/presentation/home/content/home_tablet_layout.dart';
import 'package:flutter/material.dart';

class HomeAdaptiveLayout extends StatelessWidget {
  const HomeAdaptiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 840) {
      return const HomeDesktopLayout();
    } else if (width >= 600) {
      return const HomeTabletLayout();
    }
    return const HomeMobileLayout();
  }
}
```

> Cada layout alternativo (`HomeDesktopLayout`, `HomeTabletLayout`, `HomeMobileLayout`) é uma classe pública em `content/` — nunca um método `_buildXxx()` privado dentro da View.

## Layout Fundamentals

### Understanding Constraints

Flutter layout follows one rule: **Constraints go down. Sizes go up. Parent sets position.**

Widgets receive constraints from parents, determine their size, then report size up to parent. Parents then position children.

Key limitation: Widgets can only decide size within parent constraints. They cannot know or control their own position.

For detailed examples and edge cases, see [layout-constraints.md](references/layout-constraints.md).

### Common Layout Patterns

**Row/Column**
- `Row` arranges children horizontally
- `Column` arranges children vertically
- Control alignment with `mainAxisAlignment` and `crossAxisAlignment`
- Use `Expanded` to make children fill available space proportionally

**Container**
- Add padding, margins, borders, background
- Can constrain size with width/height
- Without child/size, expands to fill constraints

**Expanded/Flexible**
- `Expanded` forces child to use available space
- `Flexible` allows child to use available space but can be smaller
- Use `flex` parameter to control proportions

For complete widget documentation, see [layout-basics.md](references/layout-basics.md) and [layout-common-widgets.md](references/layout-common-widgets.md).

## Best Practices

### Design Principles

**Break down widgets**
- Create small, focused widgets instead of large complex ones
- Improves performance with `const` widgets
- Makes testing and refactoring easier
- Share common components across different layouts
- **NUNCA** use `Widget _buildXxx()` — extraia para `content/` (auxiliar da View) ou `widgets/` / `common/widgets/` (reutilizável)

**Design to platform strengths**
- Mobile: Focus on capturing content, quick interactions, location awareness
- Tablet/Desktop: Focus on organization, manipulation, detailed work
- Web: Leverage deep linking and easy sharing

**Solve touch first**
- Start with great touch UI
- Test frequently on real mobile devices
- Layer on mouse/keyboard as accelerators, not replacements

### Implementation Guidelines

**Never lock orientation**
- Support both portrait and landscape
- Multi-window and foldable devices require flexibility
- Locked screens can be accessibility issues

**Avoid device type checks**
- Don't use `Platform.isIOS`, `Platform.isAndroid` for layout decisions
- Use window size instead
- Device type ≠ window size (windows, split screens, PiP)

**Use breakpoints, not orientation**
- Don't use `OrientationBuilder` for layout changes
- Use `MediaQuery.sizeOf` or `LayoutBuilder` with breakpoints
- Orientation doesn't indicate available space

**Don't fill entire width**
- On large screens, avoid full-width content
- Use multi-column layouts with `GridView` or flex patterns
- Constrain content width for readability

**Support multiple inputs**
- Implement keyboard navigation for accessibility
- Support mouse hover effects
- Handle focus properly for custom widgets

For complete best practices, see [adaptive-best-practices.md](references/adaptive-best-practices.md).

## Capabilities and Policies

Separate what your code *can* do from what it *should* do.

**Capabilities** (what code can do)
- API availability checks
- OS-enforced restrictions
- Hardware requirements (camera, GPS, etc.)

**Policies** (what code should do)
- App store guidelines compliance
- Design preferences
- Platform-specific features
- Feature flags

### Implementation Pattern

```dart
// Capability class
class Capability {
  bool hasCamera() {
    // Check if camera API is available
    return Platform.isAndroid || Platform.isIOS;
  }
}

// Policy class
class Policy {
  bool shouldShowCameraFeature() {
    // Business logic - maybe disabled by store policy
    return hasCamera() && !Platform.isIOS;
  }
}
```

Benefits:
- Clear separation of concerns
- Easy to test (mock Capability/Policy independently)
- Simple to update when platforms evolve
- Business logic doesn't depend on device detection

For detailed examples, see [adaptive-capabilities.md](references/adaptive-capabilities.md) and [capability_policy_example.dart](assets/capability_policy_example.dart).

## Examples

### Responsive Navigation

Switch between bottom navigation (small screens) and navigation rail (large screens).

**❌ ERRADO — método privado na View:**

```dart
// NUNCA faça isso dentro de um arquivo de View
Widget build(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width >= 600
      ? _buildNavigationRailLayout()  // ❌ proibido
      : _buildBottomNavLayout();       // ❌ proibido
}
```

**✅ CORRETO — widgets extraídos para `common/widgets/`:**

```dart
// lib/common/widgets/adaptive_nav_rail.dart
import 'package:flutter/material.dart';

class AdaptiveNavRail extends StatelessWidget {
  const AdaptiveNavRail({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    required this.body,
  });

  final int selectedIndex;
  final List<NavigationRailDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          destinations: destinations,
          onDestinationSelected: onDestinationSelected,
          labelType: NavigationRailLabelType.all,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: body),
      ],
    );
  }
}
```

```dart
// lib/common/widgets/adaptive_bottom_nav.dart
import 'package:flutter/material.dart';

class AdaptiveBottomNav extends StatelessWidget {
  const AdaptiveBottomNav({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    required this.body,
  });

  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: body,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        destinations: destinations,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
```

```dart
// Uso na View — lib/presentation/home/view/home_view.dart
import 'package:base_app/common/widgets/adaptive_bottom_nav.dart';
import 'package:base_app/common/widgets/adaptive_nav_rail.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/home/view_model/home_cubit.dart';
import 'package:base_app/presentation/home/view_model/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _cubit = AppInjector.inject.get<HomeCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadHome();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final body = SafeArea(
            top: false,
            child: switch (state) {
              HomeLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              HomeLoaded(:final items) => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) => ListTile(title: Text(items[i])),
                ),
              HomeError(:final message) => Center(child: Text(message)),
              HomeInitial() => const SizedBox.shrink(),
            },
          );

          if (width >= 600) {
            return Scaffold(
              appBar: AppBar(
                title: Text(context.l10n.homeTitle),
              ),
              body: AdaptiveNavRail(
                selectedIndex: 0,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text(''), // label via l10n na View real
                  ),
                ],
                onDestinationSelected: (_) {},
                body: body,
              ),
            );
          }

          return AdaptiveBottomNav(
            selectedIndex: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: '', // label via l10n na View real
              ),
            ],
            onDestinationSelected: (_) {},
            body: body,
          );
        },
      ),
    );
  }
}
```

Complete example: [responsive_navigation.dart](assets/responsive_navigation.dart)

### Adaptive Grid

Use `GridView.extent` with responsive maximum width:

```dart
// Pode estar em content/ como widget auxiliar da View
LayoutBuilder(
  builder: (context, constraints) {
    return GridView.extent(
      maxCrossAxisExtent: constraints.maxWidth < 600 ? 150 : 200,
      // ...
    );
  },
)
```

## Resources

### Reference Documentation
- [layout-constraints.md](references/layout-constraints.md) - Complete guide to Flutter's constraint system with 29 examples
- [layout-basics.md](references/layout-basics.md) - Core layout widgets and patterns
- [layout-common-widgets.md](references/layout-common-widgets.md) - Container, GridView, ListView, Stack, Card, ListTile
- [adaptive-workflow.md](references/adaptive-workflow.md) - Detailed 3-step adaptive design approach
- [adaptive-best-practices.md](references/adaptive-best-practices.md) - Design and implementation guidelines
- [adaptive-capabilities.md](references/adaptive-capabilities.md) - Capability/Policy pattern for platform behavior

### Example Code
- [responsive_navigation.dart](assets/responsive_navigation.dart) - NavigationBar ↔ NavigationRail switching
- [capability_policy_example.dart](assets/capability_policy_example.dart) - Capability/Policy class examples

### Scripts
This skill currently has no executable scripts. All guidance is in reference documentation.

### Assets
This skill includes complete Dart example files demonstrating:
- Responsive navigation patterns
- Capability and Policy implementation
- Adaptive layout strategies

These assets can be copied directly into your Flutter project or adapted to your needs.
