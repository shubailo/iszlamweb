# PLAN-worship-redesign-kotatsu (The Functional Worship Hub)

> **Goal:** Transform the static "Prayer Timetable" into a **Functional Dashboard** inspired by the [Kotatsu App](https://github.com/KotatsuApp/Kotatsu) (Clean Material 3 Lists + Actions).
> **Key Insight:** Kotatsu is great because it shows **Status** (Read/Unread) and **Actions** (Download) directly in the list. We will do the same for Prayers (Prayed/Missed) and Tools.

## 1. The Design Philosophy (Stealing from Kotatsu)
Kotatsu uses a dense, information-rich **List View** for chapters and a **Grid View** for library items.

### A. The "Prayer Chapter" List (Timeline)
Instead of a text row (`Fajr 05:00`), we treat each prayer like a **Manga Chapter**:
*   **Leading:** Dynamic Icon (Sun/Moon) + Time (Big & Bold).
*   **Title:** Prayer Name (Fajr).
*   **Subtitle:** "Iqama: 05:15" (Smart Jamat Data).
*   **Trailing Action:**
    *   **Checkbox:** Mark as "Prayed" (Green).
    *   **Bell:** Toggle Notification (Filled/Outlined).
*   **Status Indicators:**
    *   **Current:** Highlighted Background (Active Chapter).
    *   **Missed:** Red dot (Unread Chapter).

### B. The "Toolbar Library" (Grid)
Above the list, we place a **Horizontal Grid** of tools (like Kotatsu's Library categories):
*   [📿 Tasbih]
*   [🧭 Qibla]
*   [🕌 Map]
*   [📖 Quran]

## 2. Implementation Steps

### Step 1: The `PrayerTracker` Model
- [ ] Create `PrayerStatus` (Pending, Prayed, Missed).
- [ ] Create `PrayerTrackerProvider` (Local storage for daily status).

### Step 2: The "Kotatsu List Tile"
- [ ] Redesign `_PrayerTile` to be a `PrayerActionTile`.
- [ ] Add `Checkbox` and `IconButton` logic.
- [ ] Add "Active State" styling (The "Next Prayer" highlights like a selected chapter).

### Step 3: The "Spiritual Toolbar"
- [ ] Create a horizontal scrollable row of **Action Chips** or **Compact Cards**.
- [ ] Implement the **Smart Tasbih** (Simple counter dialog for MVP).

## 3. Why this works?
- **Familiarity:** It uses standard Material 3 patterns (like Kotatsu).
- **Utility:** Users don't just *look* at the time; they *interact* with it (Check off, Toggle alarm).

## 4. Verification
- [ ] **Test:** Checklist state persists after app restart.
- [ ] **Test:** "Next Prayer" highlighted correctly.
