# IMPLEMENTATION PLAN - Islamic Calendar (Hijri Modal)

## 📌 Context
The user wants to replace the "Imarendek" button on the **Sanctuary Dashboard** with an **Islamic Calendar (Naptár)**.
Clicking this button should open a modal that shows a Gregorian/Hijri calendar. Selecting a date should update the dashboard to show prayer times for *that* specific date, not just today.

**Goal:** Provide a way to check prayer times for any date via a calendar interface.

---

## 🏗️ Architecture

### 1. Data & Logic
*   **State Management**: `PrayerParamsProvider` (new) to hold the *selected date* (defaults to `DateTime.now()`).
*   **Hijri Date**: Use `hijri` package to convert Gregorian dates to Hijri for the UI.
*   **Prayer Times**: Update `prayerTimesProvider` to accept a `date` parameter (or watch the `selectedDate` provider).

### 2. UI Components
*   **Calendar Modal (`_CalendarModal`)**:
    *   Uses `table_calendar` (standard Flutter pkg) for the grid.
    *   Custom cell builders to show Hijri day number below Gregorian day.
    *   "Go to Today" button.
*   **Sanctuary Screen Updates**:
    *   **Hero Section**: Display the *selected* date (Hijri & Gregorian).
    *   **Prayer List**: Show times for the *selected* date.
    *   **"Imarendek" Button**: Rename to "Naptár", change icon to `Icons.calendar_month`.

---

## 📋 Implementation Steps

### Phase 1: Dependencies & State
- [ ] Add `table_calendar` and `hijri` to `pubspec.yaml`.
- [ ] Create `selectedDateProvider` in `feature/worship/providers/`.
- [ ] Refactor `SanctuaryScreen` to watch `selectedDateProvider` instead of using `DateTime.now()` directly.

### Phase 2: The Calendar Modal
- [ ] Create `features/worship/widgets/islamic_calendar_modal.dart`.
- [ ] Implement `TableCalendar` with:
    *   Gregorian dates (main).
    *   Hijri dates (subtitle in cell).
    *   Selection logic (updates `selectedDateProvider`).

### Phase 3: Dashboard Integration
- [ ] In `SanctuaryScreen`, update `_buildToolsSection`:
    *   Change "Imarendek" -> "Naptár".
    *   OnTap -> `showModalBottomSheet(builder: (_) => IslamicCalendarModal())`.
- [ ] Update `_buildHero` and `_buildPrayerTimesCard` to reflect the watched `selectedDate`.

### Phase 4: Polish
- [ ] Style the calendar to match `GardenPalette` (Green/Gold theme).
- [ ] Add "Reset to Today" floating button in the modal.

---

## 🧪 Verification Plan

### Manual Verification
1.  Open Sanctuary Tab.
2.  Click "Naptár" button.
3.  Select a date in the future (e.g., start of Ramadan).
4.  Verify the Dashboard Hero now shows that future date.
5.  Verify Prayer Times card shows correct times for that future date.
6.  Click "Today" or reset, verify return to current times.

---

## 📦 Dependencies
*   `table_calendar`: ^3.1.0 (Standard)
*   `hijri`: ^3.0.0 (For calculation)
