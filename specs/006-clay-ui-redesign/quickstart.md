# Quickstart: Clay UI Design System Redesign

**Date**: 2026-03-12 | **Feature**: 006-clay-ui-redesign

## Prerequisites

- Flutter 3.x SDK installed
- Project cloned and on branch `006-clay-ui-redesign`
- `flutter pub get` completed

## Implementation Order

### Phase 1: Foundation (do first, everything depends on this)

1. **Replace `app_colors.dart`** with clay color tokens (see data-model.md → ClayColors)
2. **Create `clay_shadows.dart`** with multi-layer shadow presets (see data-model.md → ClayShadow)
3. **Create `clay_radii.dart`** with border radius hierarchy (see data-model.md → ClayRadii)
4. **Replace `app_text_styles.dart`** with clay typography (Nunito/DM Sans + preserved Amiri)
5. **Update `app_spacing.dart`** — adopt existing scale, ensure it's actually imported
6. **Replace `app_theme.dart`** — new Material 3 theme using clay tokens

### Phase 2: Core Components (reusable building blocks)

7. **Create `clay_card.dart`** — universal clay card with shadow layers, glass effect, tap lift
8. **Create `clay_button.dart`** — 4 variants with gradient, press squish animation
9. **Create `clay_input.dart`** — recessed input with focus raise
10. **Create `background_blobs.dart`** — animated floating blob layer
11. **Update `loading_indicator.dart`** — clay-styled spinner
12. **Update `error_view.dart`** — clay card wrapping
13. **Update `empty_state.dart`** — clay styling

### Phase 3: Navigation & Shell

14. **Update `app_shell.dart`** — clay bottom nav bar styling

### Phase 4: Screen-by-Screen Redesign

15. **Home screen** — bento layout with varied clay cards
16. **Prayer times screen** — individual prayer clay cards with status hierarchy
17. **Qibla screen** — clay compass styling
18. **Quran screens** (home, surah index, reader, search, bookmarks, notes, juz index)
19. **Athkar screens** (home, list, detail)
20. **Tasbih screen** — clay counter button with squish
21. **Settings screen** — clay card groups with clay inputs/toggles

### Phase 5: Animation & Polish

22. **Animation system** — float, breathe, lift, press animations
23. **Reduced motion support** — accessibility check utility
24. **RTL shadow adjustment** — directional shadow flipping

## Key Files to Touch

| File | Action | Impact |
|------|--------|--------|
| `lib/core/constants/app_colors.dart` | Replace values | 31 files affected |
| `lib/core/constants/app_text_styles.dart` | Replace values | 25 files affected |
| `lib/core/constants/app_spacing.dart` | Update | Currently unused, will be adopted |
| `lib/core/constants/clay_shadows.dart` | New | Shadow presets for all components |
| `lib/core/constants/clay_radii.dart` | New | Border radius hierarchy |
| `lib/core/theme/app_theme.dart` | Replace | Global theme configuration |
| `lib/core/widgets/clay_card.dart` | New | Replaces IslamicCard (9 files, 17 uses) |
| `lib/core/widgets/clay_button.dart` | New | 4-variant button component |
| `lib/core/widgets/clay_input.dart` | New | Recessed input field |
| `lib/core/widgets/background_blobs.dart` | New | Animated blob background |

## Running Tests

```bash
# Run all widget tests for clay components
flutter test test/widget/

# Run a specific component test
flutter test test/widget/clay_card_test.dart

# Run with coverage
flutter test --coverage
```

## Design Reference

- Full design system spec: `FlutterClayUI.md` (project root)
- Color tokens: data-model.md → ClayColors
- Shadow presets: data-model.md → ClayShadow
- Typography: data-model.md → ClayTypography
- Component props: data-model.md → Component Models

## Common Patterns

### Using ClayCard (replaces IslamicCard)

```dart
ClayCard(
  shadowLevel: ClayShadowLevel.surface,
  onTap: () => navigateToDetail(),
  child: Column(
    children: [
      Text('Title', style: ClayTypography.cardTitle),
      Text('Body', style: ClayTypography.bodyMedium),
    ],
  ),
)
```

### Using ClayButton

```dart
ClayButton(
  variant: ClayButtonVariant.primary,
  onPressed: () => doAction(),
  child: Text('Action'),
)
```

### Adding Background Blobs to a Screen

```dart
Stack(
  children: [
    BackgroundBlobsLayer(
      blobs: [
        BackgroundBlob(color: ClayColors.primaryAccent, position: Alignment(-1.2, -0.5)),
        BackgroundBlob(color: ClayColors.secondaryAccent, position: Alignment(1.3, 0.8)),
      ],
    ),
    // Screen content here
  ],
)
```
