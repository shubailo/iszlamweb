# PLAN-kotatsu-architecture (The Unified App Layout)

> **Goal:** Re-architect the app navigation to mimic the successful **Kotatsu App** layout, creating a content-first experience.
> **Philosophy:** "Dense Lists, Functional Grids, Clear Hierarchy."

## 1. The New Navigation Structure (5 Tabs)

We are moving from a simple 2-tab app to a full-fledged **5-Tab Dashboard**:

| Kotatsu Tab | Iszlam.com Feature | Purpose | Icon |
| :--- | :--- | :--- | :--- |
| **Explore** | **Home** | News, Annoucements, "What's New" | `home_filled` |
| **Favorites** | **Worship** | Prayer Times (Main), Qibla, Tasbih | `mosque` |
| **History** | **Library** | Books, Khutbas, "Manga-style" Reader | `local_library` |
| **Feed** | **Community** | Events, Groups, Local Mosque Feed | `people` |
| **More** | **More** | Settings, Profile, Admin Tools | `menu` |

## 2. Tab Breakdown

### Tab 1: Home (The "Explore" Feed)
*   **Hero Section:** "Daily Verse" or "Featured Event".
*   **Quick News:** Horizontal scroll of latest announcements.
*   **Upcoming:** "Next Prayer" countdown (Small widget).

### Tab 2: Worship (The "Functional Dashboard")
*   **Layout:** As planned in `PLAN-worship-redesign-kotatsu.md`.
*   **Header:** Prayer Timeline (Kotatsu Chapter List style).
*   **Toolbar:** Grid of tools (Qibla, Tasbih, Calendar).

### Tab 3: Library (The "Content Hub")
*   **Layout:** Grid View of Book Covers (Manga style).
*   **Interaction:**
    *   **Tap:** Open Reader (PDF/EPUB).
    *   **Long Press:** Show "About Book" modal (Description, Author).
*   **Categories:** Books, Khutbas (Audio), Articles.

### Tab 4: Community (The "Local Feed")
*   **Current:** The existing `CommunityFeedScreen`.
*   **Enhancement:** Add "Events" and "Groups" as tabs at the top (Kotatsu-style internal tabs).

### Tab 5: More
*   **Profile:** User settings.
*   **Admin:** Voice-to-Text, Uploads.
*   **Theme:** Dark/Light mode toggle.

## 3. Implementation Steps

### Step 1: The "Kotatsu Scaffold"
- [ ] Update `ScaffoldWithNavBar` in `main.dart` to support 5 tabs.
- [ ] Create placeholder screens for `HomeScreen`, `LibraryScreen`, `MoreScreen`.

### Step 2: Migrating Features
- [ ] Move `CommunityFeedScreen` to Tab 4.
- [ ] Move `PrayerHomeScreen` to Tab 2.
- [ ] Create new `HomeScreen` (Tab 1) aggregating data.

### Step 3: The Library Engine (Future)
- [ ] Build the "Book Grid" widget.
- [ ] Implement "Long Press" details modal.

## 4. Why this works?
- **Scalability:** We have a dedicated place for *everything* (Content, Tools, Social).
- **Familiarity:** It uses standard "Super App" navigation patterns.

## 5. Next Action
- **Refactor `main.dart`** to implement the 5-tab structure.
