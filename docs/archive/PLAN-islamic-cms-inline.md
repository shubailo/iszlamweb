# PLAN: Inline Admin Islamic CMS

## User Review Required

> [!IMPORTANT]
> This change moves core Islamic content (99 Names & Duas) from local JSON to Supabase.

*   **Inline Editing**: Admins edit content directly on the 99 Names and Duák screens.
*   **Detailed View**: 99 Names become interactive buttons opening rich info pages.

## Phase 1: Database Setup
- [ ] Run `docs/supabase_islamic_cms_v2.sql` in Supabase.
- [ ] Verify RLS policies (Public Read, Admin Write).

## Phase 2: Data Models
- [ ] Create `lib/shared/models/asmaul_husna.dart` (extended fields).
- [ ] Create `lib/features/worship/models/dua.dart`.

## Phase 3: Infrastructure
- [ ] Add CRUD methods to `AdminRepository`.
- [ ] Create `asmaulHusnaProvider` (Supabase + local fallback).
- [ ] Create `duasProvider`.

## Phase 4: UI Enhancements (User)
- [ ] Update `AsmaulHusnaScreen` cards to be clickable.
- [ ] Create `AsmaulHusnaDetailScreen` with rich text info.

## Phase 5: UI Enhancements (Admin)
- [ ] Implement `AdminAddCard` for names and duas.
- [ ] Add edit/delete overlay icons for admins.
- [ ] Create `EditAsmaDialog` and `EditDuaDialog`.

## Phase 6: Verification
- [ ] Test admin add/edit/delete flow.
- [ ] Verify detail view rendering.
- [ ] `flutter analyze`.
