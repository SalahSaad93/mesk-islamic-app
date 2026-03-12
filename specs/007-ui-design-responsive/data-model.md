# Data Model: UI Responsiveness & Smooth Experience

**Date**: 2026-03-12 | **Feature**: 007-ui-design-responsive

> This feature introduces no new persistent storage schema. The entities below are **conceptual models** used for planning responsive layouts, test coverage, and automated checks.

## Conceptual Entities

### ResponsiveLayoutSpec

Describes how each primary screen should behave across the agreed device classes, sizes, and orientations.

| Field | Type | Description |
|-------|------|-------------|
| screenId | String | Identifier for the screen (e.g., `home`, `prayer_times`, `quran_home`) |
| sizeClass | Enum (`compact`, `regular`, `expanded`) | Logical size bucket derived from device width/height and orientation |
| orientation | Enum (`portrait`, `landscape`) | Orientation for this spec entry |
| layoutPattern | String | High-level layout pattern (e.g., `single_column`, `two_column`, `bento`) |
| minWidth | double | Minimum logical width where this variant is valid |
| maxWidth | double | Maximum logical width where this variant is valid |
| notes | String? | Additional layout rules (e.g., “stack header above list on compact”) |

### ScreenVariant

Represents a concrete layout variant for a given screen, used to reason about how content adapts.

| Field | Type | Description |
|-------|------|-------------|
| screenId | String | Links to `ResponsiveLayoutSpec.screenId` |
| variantId | String | Local identifier for this layout variant |
| sizeClass | Enum | Must match one of the `ResponsiveLayoutSpec` size classes |
| primaryComponents | List<String> | List of key UI components (e.g., header, list, FAB) included in this variant |
| scrollBehavior | String | How content is scrolled (`none`, `vertical`, `horizontal`, `both`) |
| breakpointRule | String | Human-readable description of when this variant is chosen |

### AutomatedLayoutCheck

Represents a single automated layout or visual regression check.

| Field | Type | Description |
|-------|------|-------------|
| id | String | Identifier for the check |
| screenId | String | Screen under test |
| deviceProfile | String | Named profile (e.g., `phone-compact`, `tablet-landscape-split`) |
| width | double | Logical width used for the check |
| height | double | Logical height used for the check |
| orientation | Enum (`portrait`, `landscape`) | Orientation under test |
| assertions | List<String> | High-level assertions (e.g., “no overflow”, “primary CTA visible”) |

## Relationships & Notes

- Each `ResponsiveLayoutSpec` entry can have one or more `ScreenVariant` definitions; together they describe how a screen adapts as size and orientation change.
- Each `AutomatedLayoutCheck` targets a specific `screenId` and `deviceProfile` that maps back to one or more `ResponsiveLayoutSpec` entries.
- These entities are planning tools rather than new runtime types; implementation can encode them via constants, configuration tables, or implicit layout logic in widgets.

