# PLAN: Tasbih (Rosary) Implementation

## Goal
Implement a digital Tasbih (counter) feature, inspired by `Mi-raj` but modernized for `iszlamweb_app`.
Focus on a clean, "Infinity" style counter with 33/99 cycle indicators.

## Architecture
- **State Management**: `Riverpod` (`StateNotifier` for counter).
- **Persistence**: Save count/loops to `SharedPreferences`.
- **Haptics**: Use Flutter's native `HapticFeedback`.
- **UI**: 
    - Large tappable area.
    - Circular progress indicator for the 33-count cycle.
    - Total count display.
    - Reset button.

## Proposed Changes

### 1. Dependencies
- No new external packages.
- Use `flutter_animate` (already in project) for click effects.
- Use `shared_preferences` (already in project) for persistence.

### 2. Assets
- [COPY] `references/Mi-raj/assets/img/tasbih.png` -> `assets/tools/tasbih.png` (Optional, maybe just use Icon).

### 3. Implementation

#### [NEW] `features/tools/providers/tasbih_provider.dart`
- `TasbihState`: `{ int count, int cycle, int total }`.
- `TasbihNotifier`: Methods `increment()`, `reset()`. Handles `HapticFeedback`.

#### [NEW] `features/tools/screens/tasbih_screen.dart`
- **Visuals**:
    - "Glass" container for the counter.
    - Big circular count indicator (0-33).
    - Session total at the bottom.
- **Interactions**:
    - Tap anywhere to count.
    - Vibrate on every tap.
    - Heavy vibrate on 33/99 completion.

### 4. Integration
- Add route `/tasbih` in `router.dart`.
- Link in `QuickToolsRow`.

## Verification Plan
### Manual Verification
1.  **Counting**: Tap and verify number increases.
2.  **Cycles**: Tap to 33. Verify cycle count increases or progress resets.
3.  **Haptics**: Verify vibration on tap (device required).
4.  **Persistence**: Restart app. Verify count is remembered.
