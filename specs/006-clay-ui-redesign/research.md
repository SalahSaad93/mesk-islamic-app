# Research: Clay UI Design System Redesign

**Date**: 2026-03-12 | **Feature**: 006-clay-ui-redesign

## R1: Multi-Layer Clay Shadow Performance in Flutter

**Decision**: Use `DecoratedBox` with `BoxShadow` list (max 4 layers) for clay effect; provide a reduced shadow preset (2 layers) for performance-sensitive contexts like scrolling lists.

**Rationale**: Flutter's `BoxShadow` supports multiple shadows natively. 4-layer shadows render efficiently on GPU-accelerated devices. However, in `ListView` with 50+ items, each item having 4 shadows can cause frame drops on lower-end devices. A 2-layer "lite" shadow preset maintains the clay feel while keeping scrolling at 60 FPS.

**Alternatives considered**:
- CustomPainter with cached shadow bitmaps: More complex, harder to maintain, marginal performance gain
- Single-shadow with blur: Too flat, loses the clay volumetric effect entirely
- `RepaintBoundary` per card: Helps with repaints but adds memory overhead per widget

## R2: Animated Background Blobs Implementation

**Decision**: Use `CustomPainter` with `AnimationController` for blob rendering. Limit to 2-3 blobs per screen. Use `RepaintBoundary` to isolate blob repaints from content layer.

**Rationale**: Blobs are large, blurred, low-opacity circles that drift slowly. `CustomPainter` is efficient for this since it avoids widget tree overhead. `BackdropFilter` with `ImageFilter.blur` is too expensive for continuous animation. Instead, pre-blur the gradient circles in the painter using radial gradients with soft edges (no runtime blur needed).

**Alternatives considered**:
- `BackdropFilter` + animated `Positioned` widgets: Too expensive (re-blurs every frame)
- Static background image: Loses animation, feels lifeless
- Shader-based: Over-engineered for simple floating circles

## R3: Font Strategy (Nunito + DM Sans via Google Fonts)

**Decision**: Add Nunito and DM Sans through the existing `google_fonts` ^6.2.1 dependency. Continue using Amiri for Arabic text. Bundle fonts as assets for offline support.

**Rationale**: `google_fonts` handles font loading, caching, and fallback. Both Nunito and DM Sans are available in the package. For a production app that may be used offline (common in Islamic apps), fonts should be bundled as assets using `google_fonts`'s `GoogleFonts.config.allowRuntimeFetching = false` with pre-downloaded font files.

**Alternatives considered**:
- Runtime-only font fetching: Risk of missing fonts on first launch or in offline mode
- Custom font files without google_fonts: More manual work, lose the convenience of the package API

## R4: Press/Squish Animation Pattern

**Decision**: Use `AnimatedScale` (or `ScaleTransition` with `AnimationController`) wrapping buttons. Scale down to 0.95 on `onTapDown`, return to 1.0 on `onTapUp`/`onTapCancel`. Duration: 100ms down, 150ms up with `Curves.easeOut`.

**Rationale**: `AnimatedScale` is lightweight, declarative, and handles the common press animation pattern well. The 0.95 scale factor gives a subtle but noticeable "squish" feel without being distracting. Combined with shadow depth changes (reducing outer shadow on press, adding inner shadow), this creates the tactile clay press effect.

**Alternatives considered**:
- `Transform.scale` with manual `AnimationController`: More control but more boilerplate
- `AnimatedContainer` with size change: Causes layout shifts in parent
- Rive/Lottie animations: Over-engineered for a scale transform

## R5: IslamicCard → ClayCard Migration Strategy

**Decision**: Create `ClayCard` as a new widget. Update all 9 files (17 occurrences) that import `IslamicCard` to use `ClayCard`. Keep `IslamicCard` as a deprecated re-export of `ClayCard` temporarily for any missed references. Remove in follow-up cleanup.

**Rationale**: `ClayCard` has different default properties (32px radius vs 16px, multi-layer shadows vs single, different colors). A wrapper approach would add complexity. Direct replacement is cleaner since all usages are tracked (9 files, 17 occurrences).

**Alternatives considered**:
- In-place modification of IslamicCard: Confusing name for a non-Islamic-green card
- Adapter/wrapper pattern: Adds indirection for no benefit since all call sites change anyway

## R6: Color Token Migration (31 files)

**Decision**: Replace `AppColors` constants in-place with new clay palette values. All 31 importing files will automatically get the new colors. Screen-specific color overrides will be updated per screen.

**Rationale**: Since `AppColors` is a centralized constants file, changing the values propagates to all consumers. Files that use `AppColors.primaryAccent` for semantic purposes (e.g., prayer active state) will need individual review to map to the correct clay accent color.

**Semantic mapping**:
- `primaryGreen` (#1A7A4A) → `primaryAccent` (#7C3AED)
- `primaryGreenLight` → `primaryAccentLight` (lighter violet)
- `backgroundLight` (#EBF5EE) → `canvas` (#F4F1FA)
- `goldAccent` → `warningAccent` (#F59E0B, same hue)
- `textDark` (#1A1A2E) → `textPrimary` (#332F3A)
- `textMedium` → `textSecondary` (#635F69)

## R7: Reduced Motion Accessibility

**Decision**: Check `MediaQuery.disableAnimations` (Flutter 3.x) to globally disable or minimize animations. Wrap all animation controllers in a utility that respects this setting.

**Rationale**: Flutter provides `MediaQueryData.disableAnimations` which reflects the platform's "reduce motion" accessibility setting. Creating a `ClayAnimationUtil.shouldAnimate(context)` helper ensures consistent behavior across all animated components.

**Alternatives considered**:
- Per-widget accessibility checks: Duplicated logic, easy to miss
- Global animation speed multiplier: Doesn't fully disable, just slows down

## R8: RTL Shadow Direction

**Decision**: Use `Directionality.of(context)` to determine text direction and flip shadow offsets horizontally for RTL. Light source moves from top-left (LTR) to top-right (RTL).

**Rationale**: The clay design system assumes top-left lighting. In RTL layouts, visual consistency requires mirroring the light source. This is a simple offset negation on the x-axis of shadow offsets.

**Alternatives considered**:
- Ignoring RTL shadow direction: Visually jarring; light appears to come from wrong side
- Separate shadow definitions per direction: Duplicated constants, harder to maintain
