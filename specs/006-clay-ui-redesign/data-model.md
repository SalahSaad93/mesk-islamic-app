# Data Model: Clay UI Design System

**Date**: 2026-03-12 | **Feature**: 006-clay-ui-redesign

> This feature has no persistent data model changes. All entities below are **UI component models** (widget configurations and design tokens) that exist only in the presentation layer.

## Design Token Entities

### ClayColors

Centralized color palette replacing `AppColors`.

| Token | Value | Replaces |
|-------|-------|----------|
| canvas | #F4F1FA | backgroundLight (#EBF5EE) |
| surface | #FFFFFF | cardBackground (#FFFFFF) |
| primaryAccent | #7C3AED | primaryGreen (#1A7A4A) |
| primaryAccentLight | #A78BFA | primaryGreenLight (#2D9E63) |
| primaryAccentDark | #5B21B6 | primaryGreenDark (#145C38) |
| secondaryAccent | #DB2777 | — (new) |
| tertiaryAccent | #0EA5E9 | — (new) |
| success | #10B981 | success (#43A047) |
| warning | #F59E0B | goldAccent (#F0A500) |
| textPrimary | #332F3A | textDark (#1A1A2E) |
| textSecondary | #635F69 | textMedium (#4A4A6A) |
| textTertiary | #9CA3AF | textLight (#8A8AA0) |
| textOnPrimary | #FFFFFF | textWhite (#FFFFFF) |
| error | #EF4444 | error (#E53935) |
| divider | #E5E7EB | divider (#E8EDF0) |
| border | #D1D5DB | border (#DDE3E9) |
| shadowColor | rgba(124,58,237,0.08) | shadow (rgba(0,0,0,0.1)) |
| highlightColor | rgba(255,255,255,0.8) | — (new) |

### ClayRadii

Border radius hierarchy.

| Token | Value | Usage |
|-------|-------|-------|
| containerLarge | 48–60px | Large containers, hero cards |
| card | 32px | Standard cards |
| medium | 24px | Medium elements, dialogs |
| button | 20px | Buttons, inputs |
| icon | 16px / circular | Icon containers |
| badge | 8px | Badges, small tags |

### ClayShadow

Multi-layer shadow configuration per elevation level.

| Level | Layers | Usage |
|-------|--------|-------|
| surface | 4 layers: outer (0,8,32,-4, 8% primary), highlight (0,-2,8,0, 80% white), inner reflection, inner rim | Cards, containers |
| surfaceLite | 2 layers: outer + highlight only | List items in scrolling contexts |
| button | 4 layers: stronger outer (0,6,20,-2), convex highlight, inner glow, rim | Interactive buttons |
| pressed | 2 layers: inset shadow (inset 0,2,8,0), muted outer | Pressed/active state |
| navigation | 3 layers: soft outer, highlight, subtle inner | Bottom nav bar |

**RTL behavior**: Shadow x-offsets are negated when `Directionality == RTL`.

### ClayTypography

Typography scale (replaces `AppTextStyles`).

| Style | Font | Size | Weight | Line Height | Usage |
|-------|------|------|--------|-------------|-------|
| heroTitle | Nunito | 32px | 900 | 1.2 | Hero display text |
| sectionTitle | Nunito | 24px | 800 | 1.3 | Section headings |
| cardTitle | Nunito | 18px | 700 | 1.4 | Card headings |
| bodyLarge | DM Sans | 16px | 500 | 1.5 | Primary body text |
| bodyMedium | DM Sans | 14px | 400 | 1.5 | Secondary body text |
| bodySmall | DM Sans | 12px | 400 | 1.4 | Captions, metadata |
| labelLarge | DM Sans | 14px | 700 | 1.0 | Button labels |
| labelSmall | DM Sans | 10px | 700 | 1.0 | Uppercase small labels |
| countdownTimer | Nunito | 36px | 900 | 1.0 | Prayer countdown |
| tasbihCounter | Nunito | 64px | 900 | 1.0 | Tasbih count display |
| arabicHeading | Amiri | 28px | 700 | 1.8 | Arabic headings (preserved) |
| arabicBody | Amiri | 22px | 400 | 2.0 | Arabic body text (preserved) |
| arabicSmall | Amiri | 18px | 400 | 1.8 | Arabic small text (preserved) |
| arabicLarge | Amiri | 32px | 700 | 2.0 | Arabic large text (preserved) |

## Component Models

### ClayCard

| Property | Type | Default | Notes |
|----------|------|---------|-------|
| child | Widget | required | Card content |
| padding | EdgeInsets | 20px all | Internal padding |
| margin | EdgeInsets | 0 | External margin |
| borderRadius | double | 32px (ClayRadii.card) | Corner radius |
| shadowLevel | ClayShadowLevel | surface | shadow preset |
| backgroundColor | Color | ClayColors.surface | Card fill |
| glassEffect | bool | false | Optional frosted glass overlay |
| onTap | VoidCallback? | null | Tap handler (adds lift animation) |
| liftOnTap | bool | true | Whether to animate lift on tap |

### ClayButton

| Property | Type | Default | Notes |
|----------|------|---------|-------|
| child | Widget | required | Button content |
| onPressed | VoidCallback? | null | Press handler |
| variant | ClayButtonVariant | primary | primary/secondary/outline/ghost |
| size | ClayButtonSize | medium | small/medium/large |
| borderRadius | double | 20px (ClayRadii.button) | Corner radius |
| gradient | Gradient? | null (uses variant default) | Custom gradient override |
| isLoading | bool | false | Shows loading indicator |
| minTouchTarget | double | 48dp | Minimum touch area (constitution) |

**Variant definitions**:
- **primary**: Gradient fill (light violet → #7C3AED), white text, convex shadow
- **secondary**: Solid neutral fill (#F3F4F6), dark text, subtle shadow
- **outline**: Transparent fill, accent border, accent text, no shadow
- **ghost**: Transparent fill, accent text, no border, hover highlight only

### ClayInput

| Property | Type | Default | Notes |
|----------|------|---------|-------|
| controller | TextEditingController? | null | Text controller |
| hintText | String? | null | Placeholder text |
| borderRadius | double | 20px | Corner radius |
| shadowLevel | ClayShadowLevel | pressed | Recessed appearance |
| focusShadowLevel | ClayShadowLevel | surface | Raised on focus |
| prefixIcon | Widget? | null | Leading icon |
| suffixIcon | Widget? | null | Trailing icon |

### BackgroundBlob

| Property | Type | Default | Notes |
|----------|------|---------|-------|
| color | Color | required | Blob accent color (low opacity) |
| size | double | 200px | Blob diameter |
| opacity | double | 0.15 | Blob opacity |
| position | Alignment | required | Initial position (partially offscreen) |
| animationDuration | Duration | 8 seconds | Full drift cycle |
| driftRange | double | 30px | Vertical drift distance |

### BackgroundBlobsLayer

| Property | Type | Default | Notes |
|----------|------|---------|-------|
| blobs | List<BackgroundBlob> | 2-3 per screen | Blob definitions |
| respectReducedMotion | bool | true | Disables animation if platform setting on |

## State Transitions

### ClayButton Press States

```
idle → [onTapDown] → pressing → [onTapUp] → idle
                   → [onTapCancel] → idle

idle:     scale=1.0, shadow=button (convex)
pressing: scale=0.95, shadow=pressed (inset), duration=100ms
return:   scale=1.0, shadow=button (convex), duration=150ms, curve=easeOut
```

### ClayCard Tap States

```
idle → [onTapDown] → lifting → [onTapUp] → navigating/idle
                   → [onTapCancel] → idle

idle:     translateY=0, shadow=surface
lifting:  translateY=-2px, shadow enhanced, duration=100ms
return:   translateY=0, shadow=surface, duration=150ms
```
