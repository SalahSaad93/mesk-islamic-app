# Quickstart: UI Responsiveness & Smooth Experience (007-ui-design-responsive)

## Goal

Verify that all primary screens in the Mesk Islamic App are visually responsive and feel smooth on Android and iOS phones and tablets (portrait/landscape, including split-view where supported).

## Running the App

```bash
flutter pub get
flutter run
```

Run on at least:

- One Android phone (compact width, portrait + landscape)
- One iOS phone
- One tablet (Android or iPad) in portrait, landscape, and split-view / multi-window

## Test Commands

### Unit & Integration Tests (existing project standard)

```bash
flutter test test/unit/
flutter test test/integration/
```

### Widget Tests (add or extend for this feature)

```bash
flutter test test/widget/
```

Focus new/updated widget tests on:

- Home, prayer times, Quran home, athkar home, and qibla screens rendered with small and large `MediaQuery` sizes.
- Verifying that key widgets are present and no obvious overflow occurs on representative sizes.

## Manual Verification Checklist

On each target device/profile:

- Open **Home**, **Prayer Times**, **Quran**, **Athkar**, **Qibla**, **Settings** screens.
- Rotate between **portrait** and **landscape**:
  - No clipped text or UI elements.
  - No horizontal scrolling for primary content.
- On a **tablet** (and split-view if available):
  - Layout makes sensible use of extra width (not cramped or oddly stretched).
- With **larger system text size** enabled:
  - Critical flows remain readable and usable (content may stack and scroll instead of truncating).
- On a **content-heavy screen** (e.g., long lists):
  - Scrolling feels smooth; no obvious jank on mid‑range hardware.

## Performance & Profiling

- Use Flutter DevTools on at least one content-heavy screen to confirm:
  - Smooth frame times during scroll.
  - No major memory spikes or leaks caused by layout changes.
- Compare behavior against the main branch if there is any doubt about a regression.

