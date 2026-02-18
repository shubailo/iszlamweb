# PLAN: Bento Home Tab Redesign

Redesign the Home Tab to follow a modern Bento Grid layout, incorporating "Friss hírek" (News) and "Friss események" (Events) with high-end expansion animations.

## User Requirements
1.  **Mock Data**: Use static data for initial build.
2.  **Behavior**: Maintain existing Guest/Auth state switching.
3.  **Layout**: "Daily Wisdom" and "Prayer Countdown" at the top.
4.  **Animation**: Tiles expand in-place to reveal more content.

## Architecture

### 1. Data Layer
- **`home_mock_data.dart`**: Riverpod providers returning lists of `BentoItem` (title, description, image, type).

### 2. UI Components
- **`BentoTile`**: A widget that accepts a `BentoItem`.
    - *State*: `isExpanded` boolean.
    - *Animation*: `AnimatedContainer` for size change, `AnimatedCrossFade` or `AnimatedOpacity` for content reveal.
    - *Style*: Glassmorphism, `GardenPalette` colors, geometric background shapes.
- **`BentoGrid`**: A responsive layout (likely `StaggeredGrid` or custom `Column` of `Row`s) to hold the tiles.
    - Sections: "Friss hírek" (News), "Friss események" (Events).

### 3. Integration
- **`HomeScreen`**:
    - Keep `DailyWisdomHero` at top.
    - Keep `LivePrayerCountdown` (if active).
    - Replace `MiniDashboard`/`GuestDiscoveryGrid` area with `BentoGrid`.

## Task Breakdown

### Phase 1: Foundation
- [ ] Create `BentoItem` model.
- [ ] Create `home_mock_data.dart` with fake News and Events.

### Phase 2: Components
- [ ] Create `BentoTile` widget with expansion logic.
- [ ] Create `BentoGrid` widget layout.

### Phase 3: Integration
- [ ] Integrate into `HomeScreen`.
- [ ] Ensure Auth state toggles between Dash/Grid if required (or merge them as per "Option B" inspiration but keeping "Option A" layout).
    *Clarification*: User said "behave same way", so we might keep the switching logic but use Bento for the "Guest" or "General" content.

### Phase 4: Polish
- [ ] Add animations (flutter_animate).
- [ ] Verify responsiveness.

## ✅ PHASE X: VERIFICATION
- [ ] Layout matches AOK PTE style (Bento grid).
- [ ] Animations are smooth.
- [ ] No overflow errors on expansion.
