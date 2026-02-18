# IMPLEMENTATION PLAN - Sanctuary Dashboard (Worship Hub)

## 📌 Context
The user wants to repurpose **Tab 1** (currently "Feed") into a **Sanctuary (Hitélet)** tab.
This dashboard will serve as the user's personal spiritual center, inspired by *Muslim-App* and *Mawaqit*, focusing on daily worship tools before social connection.

**Goal:** Create a serene, utility-focused home screen.

---

## 🏗️ Architecture

### 1. Navigation Changes
*   **Rename Tab 1**: "Hírfolyam" (Feed) &rarr; "Hitélet" (Sanctuary/Worship).
*   **Move Feed**: The community feed widget will be moved to **Tab 2 (My Community)** as a sub-tab or section.

### 2. Screen Structure (`SanctuaryScreen`)
A new screen `lib/features/worship/screens/sanctuary_screen.dart` replacing `CommunityFeedScreen` in Tab 1.

**Layout Components:**
1.  **Dynamic Background**: Gradient/Image changing with time of day (using `GardenPalette`).
2.  **Hero Section (Prayer Timer)**:
    *   Next prayer name & countdown.
    *   Hijri Date.
    *   Location name.
3.  **Quick Actions Grid** (3-4 buttons):
    *   **Qibla**: Navigate to `/qibla`.
    *   **Tasbih**: Navigate to new Tasbih screen (or modal).
    *   **Quran/Duas**: Direct link or modal.
4.  **Daily Inspiration Card**:
    *   "Verse of the Day" or "Hadith".
    *   Share button.
5.  **Community Teaser** (Optional):
    *   Small strip: "3 new announcements in your community" (nudges user to Tab 2).

### 3. Data Providers
*   `PrayerTimeProvider`: Existing (needs to be robust for the countdown).
*   `DailyContentProvider`: New provider to fetch daily verse/hadith (mock for now).

---

## 📋 Implementation Steps

### Phase 1: Navigation & Routing
- [ ] Rename Tab 1 label in `hungarian_strings.dart` to "Hitélet".
- [ ] Update `main.dart` route for Branch 0 to point to `SanctuaryScreen` (to be created).
- [ ] Update `ResponsiveNavigationShell` icons (use `Icons.mosque` or similar).

### Phase 2: The Sanctuary Screen
- [ ] Create `features/worship/screens/sanctuary_screen.dart`.
- [ ] Implement **Hero Section**:
    *   Digital Clock / Countdown.
    *   Current Prayer info.
- [ ] Implement **Tools Grid**:
    *   Reuse `_CommunityCard` style or create `_ToolCard`.
    *   Link Qibla and Prayer Times details.

### Phase 3: Feed Migration
- [ ] Modify `features/community/screens/my_community_screen.dart`:
    *   Add "Feed" as the *first* tab in the `TabBarView` (Feed, Mosques, Events, Groups).
    *   Ensure `CommunityFeedScreen` content is accessible here.

### Phase 4: Polish
- [ ] Add animations (fade in entrance).
- [ ] Verify "Gold/Green" aesthetic matches `GardenPalette`.

---

## 🧪 Verification Plan

### Automated Tests
*   Verify navigation to Tab 1 loads `SanctuaryScreen`.
*   Verify clicking "Community" (Tab 2) shows the Feed.

### Manual Verification
*   **Visual**: Check gradient transitions.
*   **Functional**: Click Qibla -> Go to Qibla -> Back -> Return to Sanctuary.
*   **Functional**: Click Tab 2 -> See Feed updates.

---

## 📦 Dependencies
*   `flutter_animate`: For serene entrance animations.
*   `hijri`: (Optional) For Hijri date, or use existing lib.
