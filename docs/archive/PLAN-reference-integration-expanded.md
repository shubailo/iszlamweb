# Plan: Expanded Reference Integration

## Overview
This plan details the integration of **4 high-value feature sets** identified during the reference mining brainstorm. We will adapt proven logic and UI patterns from open-source references (`Mi-raj`, `Muslim_Mate`, `prayer-times`) to rapidly expand `iszlamweb_app`'s capabilities.

## Goals
1.  **Devotional Tools**: Add Tasbih, Asmaul Husna, and Missed Prayers tracker.
2.  **Reliability**: Replace manual prayer calculations with the battle-tested `adhan-dart` library.
3.  **User Experience**: Add a professional Onboarding flow.
4.  **Admin capabilities**: Analyze and prepare for CMS integration.

## User Review Required
> [!IMPORTANT]
> **Dependencies**: We will add `adhan` (pure dart), `shared_preferences` (if not already used widely), and `vibration` (for Tasbih).
> **Data**: We will assume `Asmaul Husna` data can be sourced from a public JSON URL or copied from the `Mi-raj` repo if available in assets (it wasn't in the code, need to check assets).

## Proposed Changes

### Phase 1: Foundation & Dependencies
#### [MODIFY] `pubspec.yaml`
- Add `adhan: ^2.0.0`
- Add `shared_preferences: ^2.2.0`
- Add `vibration: ^1.8.0` (or compatible)
- Add `google_fonts` (already there, just verifying)

### Phase 2: Prayer Engine Overhaul (`adhan-dart`)
#### [MODIFY] `lib/core/services/prayer_time_service.dart`
- **Current**: Custom `hesapla()` logic.
- **New**: Use `adhan` package.
- **Logic**:
    - Create `Coordinates` from user location.
    - Create `PrayerTimes` instance with `CalculationMethod.muslimWorldLeague` (or standard for Hungary).
    - Map `adhan` results to our `PrayerTimes` model.

### Phase 3: Devotional Tools (Option A)

#### [NEW] `lib/features/tools/screens/tasbih_screen.dart`
- **Source**: Adapted from `Muslim_Mate/lib/Screens/Tasbih_Screen.dart`.
- **UI**: Royal Garden theme (Gold/Emerald).
- **Features**: Digital counter, Vibration on tap, Reset button, Goal setting (33/99).

#### [NEW] `lib/features/tools/screens/asmaul_husna_screen.dart`
- **Source**: Logic from `Mi-raj/lib/pages/sub_pages/asmaulhusna.dart`.
- **Data**: Static list of 99 names (Name, Transliteration, Meaning). *Action: Create `assets/json/99_names.json` sourced from references.*
- **UI**: Grid or List view with calligraphy.

#### [NEW] `lib/features/tools/screens/missed_prays_screen.dart`
- **Source**: Logic from `Mi-raj/lib/pages/sub_pages/missed_prays.dart`.
- **Persistence**: Use `SharedPreferences` to store counts for Fajr...Isha.
- **UI**: Simple list with `+` / `-` buttons for each prayer type.

### Phase 4: Onboarding Flow (Option E)

#### [NEW] `lib/features/onboarding/screens/onboarding_screen.dart`
- **Source**: Adapted from `prayer-times/lib/screens/onboarding_page.dart`.
- **Flow**:
    1.  Welcome ("Békességet" - Salam)
    2.  Location Permission (Explain why)
    3.  Notification Permission (Explain why)
    4.  All Set -> Navigate to `/home`.
- **Logic**: Check `SharedPreferences` key `has_seen_onboarding`. If false, show this screen as `initialRoute`.

### Phase 5: Admin Analysis (Option H)

#### [NEW] `docs/ANALYSIS-cms-integration.md`
- Deep dive into `CMS-mobile` repo.
- Identify specific widgets/blocs to port:
    - `EventRepository` structure?
    - `AdminDashboard` UI widgets?
- Output: A specific plan for the "Admin Tools" feature upgrade.

## Verification Plan

### Automated Tests
- **Prayer Times**: Unit test comparing `adhan` lib output vs known verification timestamps (e.g. from a reliable website for Budapest).
- **JSON Parsing**: Test `99_names.json` loads correctly.

### Manual Verification
1.  **Prayer Times**:
    - Build app.
    - Check Home Screen prayer widget.
    - Compare times with a physical calendar or Google.
2.  **Devotional Tools**:
    - **Tasbih**: Tap counter, verify vibration, close app, reopen -> count should persist.
    - **Missed Prayers**: Increment "Fajr" to 5. Close app. Reopen -> should represent 5.
    - **99 Names**: Scroll through list, check text rendering.
3.  **Onboarding**:
    - Uninstall/Clear Data.
    - Launch app -> Should see Onboarding.
    - Complete flow -> Should see Home.
    - Restart app -> Should skip Onboarding.
