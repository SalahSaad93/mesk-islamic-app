# Research: Implement Remaining Features from Plan

## Phase 0: Outline & Research

**Decision 1: Text Sharing Format with `share_plus`**
- **Decision**: Send `<Arabic Text> \n <Translation>` with a concluding URL to the App Store or Verse Reference (e.g., `- Surah Al-Fatiha, Ayah 1 via [App Name]`).
- **Rationale**: Minimal yet informative payload, preventing character limits from becoming an issue natively in iOS / Android intent targets.
- **Alternatives considered**: Passing HTML formatted text or full Verse JSON blobs, both of which conflict with basic WhatsApp or iMessage sharing implementations across varied devices.

**Decision 2: Celebration Animations**
- **Decision**: A lightweight `lottie` or a simple implicit Flutter animation (`TweenAnimationBuilder`) utilizing the `goldAccent` color scaling upward before fading.
- **Rationale**: The core constitution explicitly aims for <80MB memory limits and fast UX. Loading complex Lottie JSON might delay UX or overshoot constraints.
- **Alternatives considered**: `flare` (deprecated) or heavy `.gif` inclusions.

**Decision 3: Reciter Audio Selection Data Fetch**
- **Decision**: Hardcode the reciter selection options locally into a list or load uniformly from `assets/data/reciters.json`.
- **Rationale**: The app already ships with predefined models. `reciters.json` matches the domain of an offline-first app requiring fast UI response times <100ms.
- **Alternatives considered**: Downloading options live from quran.com resulting in offline unavailability.

**Decision 4: Pull-to-Refresh Mechanism**
- **Decision**: Utilize standard Flutter `RefreshIndicator` wrapping `CustomScrollView` in both Athkar and Prayer Times screens.
- **Rationale**: It perfectly aligns with existing architecture, uses the standard Android/iOS pull semantics without heavy UI rework.
- **Alternatives considered**: Custom physics pull-downs, which often have fragile edge cases and violate iOS standard scrolling paradigms. 
