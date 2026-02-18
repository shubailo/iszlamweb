# PLAN-iszlam-community-app

> **Goal:** Create a modern "Digital Community Center" app for the Hungarian Muslim community.
> **Architecture:** Central Organization (MME) + Local Branches (Mosques).
> **Inspiration:** "Housing Society" structure (admin/governance) + "Muslim Pro" utility (prayer times).

## 1. Overview
The Iszlam.com app will be a hybrid community platform. It serves as a spiritual companion for individuals (prayer times, Quran, books) and a social hub for the community (events, mosque announcements).
It replaces the static website with a dynamic, user-centric mobile experience.

## 2. Project Type
**TYPE:** 📱 **MOBILE**
**Primary Agent:** `mobile-developer`
**Forbidden Agents:** `frontend-specialist`, `backend-specialist` (Mobile developer handles full stack for mobile)

## 3. Success Criteria
1.  **User Retention:** Users open the app daily for prayer times/content.
2.  **Community Connection:** Users successfully "join" a local mosque and receive specific updates.
3.  **Content Accessibility:** Books and Khutbas are easy to read/listen to.
4.  **Sustainability (Frictionless Admin):** Imams can post updates in <30 seconds via voice/text.

## 4. Tech Stack

| Component | Technology | Rationale |
|-----------|------------|-----------|
| **Framework** | **Flutter** | Cross-platform (iOS/Android), high performance, rich UI. |
| **Backend** | **Supabase** | Open source Firebase alternative. SQL-based (Postgres) is better for the structured "Org -> Mosque -> Member" relational data than NoSQL. |
| **State Mgmt** | **Riverpod** | Modern, strictly typed, testable state management for Flutter. |
| **Auth** | **Supabase Auth** | Secure, ready-to-use authentication. |
| **AI/ML** | **OpenAI Whisper** | For Voice-to-Text announcements (optional but recommended). |
| **Reference** | `housingsociety` | For the "Central Admin + Local Unit" architecture. |
| **Reference** | `Muslim_Mate` | For Prayer Times/Qibla algorithms. |
| **Reference** | `Mawaqit` | For "Jamat Time" data structure and display logic. |

## 5. File Structure (Proposed)

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/ (DateTime, Calculations)
├── features/
│   ├── auth/
│   ├── community/ (The "Housing Society" Logic)
│   │   ├── models/ (Mosque, Event, Announcement)
│   │   ├── screens/ (MosqueDashboard, EventList)
│   │   └── providers/
│   ├── admin_tools/ (Frictionless Admin)
│   │   ├── services/ (VoiceTranscriptionService)
│   │   └── screens/ (QuickPostScreen)
│   ├── worship/ (The "Muslim Mate" Logic)
│   │   ├── models/ (PrayerTime, Qibla)
│   │   ├── screens/ (PrayerHome, QiblaCompass)
│   │   └── services/ (AdhanService)
│   └── content/ (Books/Media)
│       ├── models/ (Book, Khutba)
│       └── screens/ (Reader, Player)
└── shared/
    ├── widgets/
    └── layout/
```

## 6. Implementation References (The "Copy/Paste" Strategy)

We will not blindly copy, but we will **adapt** logic from these open-source repos:

### A. The Structural Skeleton (`arjun-14/housingsociety`)
*   **Why:** It solves the "User belongs to Group X" problem.
*   **What to adapt:**
    *   `Notice Board` -> **Mosque Announcements**
    *   `Visitors` -> **Event Registration**
    *   `Complaints` -> **Ask Imam / Feedback**
    *   `Admin Panel` -> **Mosque Admin Dashboard**

### B. The Utility Engine (`Muslim_Mate`)
*   **Why:** Re-inventing prayer time math is error-prone.
*   **What to adapt:**
    *   `adhan_dart` package implementation.
    *   Qibla compass sensor logic.
    *   Hijri date calculations.

## 7. Feature Expansion: Frictionless Admin (Option B)
To ensure sustainability and reduce Imam burnout:
1.  **Voice-to-Announcement:** Imams record a voice note, AI transcribes it to text for the feed + attaches the audio.
2.  **Trusted Volunteers:** "Mosque Admin" role can be delegated to trusted community members, not just the Imam.
3.  **Draft & Approve:** Volunteers create posts, Imam approves with one tap.

## 8. Task Breakdown

### Phase 1: Foundation (Setup & Auth)
- [/] Initialize Flutter project with structure <!-- agent: mobile-developer -->
- [/] Setup Supabase project (Auth + Database Tables) <!-- agent: mobile-developer -->
- [ ] Implement Authentication (Login/Register/Profile) <!-- agent: mobile-developer -->

### Phase 2: The "Ummah" Engine (Community Features)
- [ ] Create `Mosques` table and selection UI (User picks home mosque) <!-- agent: mobile-developer -->
- [ ] Implement `Announcements` feed (Filtered by Mosque) <!-- agent: mobile-developer -->
- [ ] **[NEW]** Implement "Voice-to-Text" post creation logic <!-- agent: mobile-developer -->
- [ ] **[NEW]** Implement `Mosque Admin` and `Volunteer` roles (RBAC) <!-- agent: mobile-developer -->
- [ ] Implement `Events` system (Calendar + "Going" status) <!-- agent: mobile-developer -->
- [ ] **Verification:** Volunteer posts event -> Imam approves -> User sees it.

### Phase 3: The "Imaan" Engine (Worship Features)
- [ ] Implement Prayer Times service (using `adhan` package) <!-- agent: mobile-developer -->
- [ ] Build Home Dashboard (Next Prayer Countdown, Daily Dua) <!-- agent: mobile-developer -->
- [ ] Implement Qibla Compass <!-- agent: mobile-developer -->

### Phase 4: Content & Polish
- [ ] migrate Books/Khutbas content to Supabase Storage <!-- agent: mobile-developer -->
- [ ] Build EPUB/PDF Reader & Audio Player <!-- agent: mobile-developer -->
- [ ] UI Polish: "Digital Sanctuary" aesthetic <!-- agent: mobile-developer -->

## 9. Phase X: Verification Checklist

### Automated
- [ ] `flutter analyze` passes with no errors.
- [ ] `flutter test` passes for utility logic (Prayer times).

### Manual
- [ ] **Onboarding Flow:** New user can sign up and select a mosque.
- [ ] **Feed Logic:** Post an update to Mosque A, verify Mosque B user does NOT see it.
## 9. Phase 2: Polish & Content (The "Smart Companion")

### Overview
Phase 2 focuses on upgrading the app from a "Foundation" to a "Daily Companion." We will integrate **Jamat Times** (inspired by `Mawaqit`), **Mosque Map** (inspired by `Muslim_Mate`), and a polished **UI/UX**.

### New Features
1.  **Smart Jamat Times:** Display *Congregation* times for the selected mosque, not just calculation times.
2.  **Mosque Locator:** Map view to find nearby mosques.
3.  **Digital Sanctuary UI:** Apply the premium "Islamic Green" aesthetic with animations.
4.  **Real Data:** Connect to production Supabase tables.

### Task Breakdown
- [ ] **UI/UX:** Implement "Digital Sanctuary" theme (Fonts, Colors, Animations) <!-- agent: mobile-developer -->
- [ ] **Feature:** Implement `JamatTime` logic (Data model + UI) <!-- agent: mobile-developer -->
- [ ] **Feature:** Implement `MosqueMap` using `google_maps_flutter` <!-- agent: mobile-developer -->
- [ ] **Data:** creating migration scripts for real Mosque/Prayer data <!-- agent: database-specialist -->
- [ ] **Content:** Add `Quran` and `Tasbih` utilities (Basic versions) <!-- agent: mobile-developer -->

### Verification
- [ ] **Visual:** UI matches "Premium" expectation.
- [ ] **Data:** Jamat times are accurate for test mosques.
- [ ] **Map:** Locates user position and shows pins.
