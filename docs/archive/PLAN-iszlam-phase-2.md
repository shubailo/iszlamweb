# PLAN-iszlam-phase-2 (The Smart Companion)

> **Goal:** Transform Iszlam.com from a "Utility App" to a "Community Hub."
> **Strategy:** "Scrape" the best community features from **Church Center** and spiritual utilities from **Muslim Mate**/**Mawaqit**.
> **Core Value:** "Connect the Believer to the Mosque."

## 1. Overview
Phase 2 is about **Deepening Connection**.
- **Personal Connection:** My Quran, My Dhikr (Tasbih), My Prayers.
- **Mosque Connection:** My Community's Events, My Imam's Khutbas, My Study Circle.

## 2. Feature Inspiration "Scraping"

### From Church Center (The Community Engine)
We will adapt these for the Muslim context:
1.  **Events & Calendar:**
    *   *Church Center:* "Sunday Service", "Youth Group".
    *   *Iszlam.com:* **"Community Iftar"**, **"Eid Prayer Registration"**, **"Weekly Halaqa"**.
    *   *Feature:* RSVP system ("I'm going"), Event details, Location map.
2.  **Groups (Halqas):**
    *   *Church Center:* "Small Groups".
    *   *Iszlam.com:* **"Quran Study Circle"**, **"Sisters' Group"**.
    *   *Feature:* Simple list of groups, "Join" button, contact leader.
3.  **Media/Sermons:**
    *   *Church Center:* "Sermons".
    *   *Iszlam.com:* **"Jumu'ah Khutbas"**, **"Lectures"**.
    *   *Feature:* Audio player for recorded Khutbas from *your* local Imam.

### From Muslim Mate / Mawaqit (The Spiritual Engine)
1.  **Smart Jamat Times:**
    *   *Mawaqit:* Real-time *congregation* times.
    *   *Iszlam.com:* Display "Jamat: 13:15" prominent on the home screen.
2.  **Mosque Locator:**
    *   *Muslim Mate:* Map of nearby mosques.
    *   *Iszlam.com:* Google Maps integration to find & set "My Mosque".
3.  **Pocket Ibaadah:**
    *   *Muslim Mate:* Quran & Tasbih.
    *   *Iszlam.com:* Basic Quran Reader (Juz navigation) + Digital Tasbih (Counter).

## 3. Data Model Updates (Supabase)

### New Tables
*   `events`: `id`, `mosque_id`, `title`, `description`, `start_time`, `location`, `image_url`.
*   `event_attendees`: `event_id`, `user_id`, `status` (going/maybe).
*   `groups`: `id`, `mosque_id`, `name`, `description`, `leader_name`, `meeting_time`.
*   `media_content`: `id`, `mosque_id`, `type` (khutba/book), `title`, `url`, `author`.
*   `jamat_times`: `mosque_id`, `fajr_iqama`, `dhuhr_iqama`, etc. (Admin manageable).

## 4. Phase 2 Implementation Plan

### Step 1: UI/UX "Digital Sanctuary" (Foundation)
- [ ] Apply premium color palette (Deep Greens, Golds, Off-whites).
- [ ] Add smooth animations (Hero transitions for Mosque cards).
- [ ] overhaul Bottom Navigation (Home | Community | Content | Quran).

### Step 2: The "Mosque Connection" (Church Center Features)
- [ ] **Events System:** Create `Event` model and `EventsListScreen` (filtered by My Mosque).
- [ ] **Khutba Player:** Audio player for Imam's uploads.
- [ ] **Groups:** Simple directory of mosque activities.

### Step 3: The "Spiritual Utility" (Muslim Mate Features)
- [ ] **Smart Jamat Times:** Update `Mosque` model to include fixed Jamat times.
- [ ] **Mosque Map:** interactive Map View to select "Home Mosque".
- [ ] **Digital Tasbih:** Simple counter with haptic feedback.

### Step 4: Content Library
- [ ] **Books/Articles:** PDF/EPUB reader for uploaded Islamic books.

## 5. Verification
- [ ] **User Story:** "I can find my local mosque, see that Jamat is at 1:15 PM, and RSVP for the Friday If-tar."
- [ ] **User Story:** "I can listen to last week's Khutba while driving."
