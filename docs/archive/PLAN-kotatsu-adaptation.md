# PLAN: Adapt Kotatsu Layout for Iszlam.com

This plan details how we will adapt the user-friendly and logical layout of **Kotatsu** (a manga reader) into **Iszlam.com** (a community platform), creating a "My Circle" based experience.

## User Review Required

> [!IMPORTANT]
> **Technical Stack Difference:** Kotatsu is a native Android (Kotlin) app. We cannot copy code directly. We will replicate its **Logic, Layout, and User Flow** using Flutter best practices.

## Proposed Changes

We will restructure the application to follow Kotatsu's "Library-First" approach, renaming concepts to fit the Community domain.

### 1. Navigation & Shell Structure

We will implement a persistent bottom navigation bar with the following tabs, mapping Kotatsu's structure to our needs.

| Kotatsu Tab | Iszlam.com Tab | Icon | Purpose |
| :--- | :--- | :--- | :--- |
| **Library** | **My Community** | `faUserGroup` | The core hub. Shows joined Mosques, Events, and Classes. |
| **Updates** | **Feed** | `faNewspaper` | Consolidated feed of announcements *only* from followed entities. |
| **History** | **Activity** | `faClockRotateLeft` | History of check-ins, viewed content, or read books. |
| **Browse** | **Discover** | `faCompass` | Marketplace to find new communities and resources. |
| **More** | **More** | `faBars` | Settings, Profile, and **Utilities** (Prayer Times, Qibla). |

#### [NEW] [scaffold_with_nav_bar.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/navigation/scaffold_with_nav_bar.dart)
*(Refactor existing or create new)*
- Implement standard Flutter `NavigationBar`.
- Ensure state persistence between tabs (using `IndexedStack` or `integration_test` friendly routing).

### 2. Feature: My Community ("Library")

The default home view. It must not look empty for new users.

#### [NEW] [my_community_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/community/my_community_screen.dart)
- **Layout:** Grid view of "Cards" (representing Mosques/Groups).
- **Features:**
    - Filter/Sort categories (Mosques, Events, Classes).
    - "Unread" badges for new announcements.
- **Empty State:** "You haven't joined any communities yet. Go to Discover!" button.

### 3. Feature: Feed ("Updates")

A chronological timeline of content.

#### [NEW] [community_feed_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/feed/community_feed_screen.dart)
- **Layout:** List view of "Info Cards".
- **Logic:** Aggregate posts from all subscribed IDs.

### 4. Feature: Discover ("Browse")

The place to find new things.

#### [NEW] [discover_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/discovery/discover_screen.dart)
- **Layout:**
    - **Header:** "Featured" carousel (highlighting major events).
    - **Sections:** Horizontal lists for "Nearest Mosques", "Trending Events", "Recommended Reading".
    - **Search:** accessible at top.

### 5. Utilities Integration

To ensure utility is not lost, we will add a **Global Status Bar Widget**.

#### [NEW] [prayer_status_bar.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/prayer/widgets/prayer_status_bar.dart)
- Small, persistent widget (can be in AppBar or just below it) showing:
    - Current Prayer Time
    - Countdown to Next

## Verification Plan

### Automated Tests
- **Widget Tests:** Verify that switching tabs maintains state (e.g., scroll position).
- **Unit Tests:** Verify the mapping logic (e.g., pulling "Feed" only from "Joined" communities).

### Manual Verification
1.  **Navigation Flow:** Click all 5 tabs. Verify correct screen loads.
2.  **Empty State:** Launch app as new user. Verify "My Community" prompts to "Discover".
3.  **Join Flow:** Go to Discover -> Join a Mosque -> Verify it appears in "My Community".
