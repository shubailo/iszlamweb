# PLAN - App Refinement Implementation

This plan outlines the systematic implementation of high-priority features and design improvements identified during the reference audit.

## Overview
We are enhancing IszlamApp with premium UI patterns, increased privacy through encrypted chats, and a deeper focus on personal growth ("My Journey") within the Sanctuary feature.

**Project Type**: MOBILE (Flutter)

---

## Phase 1: Foundation (Security & Infrastructure)
**Objective**: Build the underlying logic for encryption and shared keys.

- [ ] **Task 1.1**: Add `encrypt` package to `pubspec.yaml`.
    - **Agent**: `mobile-developer`
    - **Verify**: `flutter pub get` succeeds.
- [ ] **Task 1.2**: Create `EncryptionService` for AES encryption/decryption.
    - **Agent**: `mobile-developer`
    - **Verify**: Unit test encrypting and decrypting a string with a static key.
- [ ] **Task 1.3**: Extend `Mosque` model and Supabase schema to include an encrypted `room_key`.
    - **Agent**: `backend-specialist`
    - **Verify**: Schema update verified in Supabase dashboard.

---

## Phase 2: UI Excellence (Global Premium Cards)
**Objective**: Apply the "Premium Layout" globally to improve the app's visual depth.

- [ ] **Task 2.1**: Refactor `LibraryItemCard` to use the overlapping detail card pattern.
    - **Agent**: `mobile-developer`
    - **Verify**: Visual check on Library screen for the "card-on-thumbnail" look.
- [ ] **Task 2.2**: Reuse this pattern for `KhutbaCard` and other list items.
    - **Agent**: `mobile-developer`
    - **Verify**: Consistent look across Library and Community feeds.

---

## Phase 3: Sanctuary Restructuring & Stats
**Objective**: Make "My Journey" (Stats) the primary view and move Prayer Times to utility.

- [ ] **Task 3.1**: Create `UserStatsService` to calculate metrics (pages read, minutes listened).
    - **Agent**: `mobile-developer`
    - **Verify**: Provider returns realistic dummy stats.
- [ ] **Task 3.2**: Restructure `SanctuaryScreen`:
    - Move Prayer Times widget to a retractable side-panel or a secondary list.
    - Set the "My Journey" Dashboard as the central Hero element.
    - **Agent**: `mobile-developer`
    - **Verify**: Navigation test in Sanctuary screen.

---

## Phase 4: Community & Maps (Manual Entry)
**Objective**: Implement the Mosque Finder and Encrypted Chat.

- [ ] **Task 4.1**: Create `MosqueMapScreen` using `flutter_map` or `google_maps_flutter`.
    - **Agent**: `mobile-developer`
    - **Verify**: Map renders and shows markers based on longitude/latitude.
- [ ] **Task 4.2**: Implement "Add Mosque" admin form (Manual Entry).
    - **Agent**: `mobile-developer`
    - **Verify**: Successfully saving a new mosque with GPS coordinates to Supabase.
- [ ] **Task 4.3**: Integrate Client-side Encryption into `ChatRoom`.
    - **Agent**: `mobile-developer`
    - **Verify**: Intercepting network traffic shows encrypted strings; UI shows decrypted messages.

---

## ✅ PHASE X: Final Verification
- [ ] **Lint**: `flutter analyze` passes.
- [ ] **Performance**: Dashboard metrics load without UI jank.
- [ ] **Security**: Verify room keys are never stored in plain text in local storage.
- [ ] **UX**: Purple check (No forbidden colors) and Accessibility audit.
