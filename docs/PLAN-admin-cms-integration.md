# IMPL PLAN: Integrated Admin CMS (Option A)

> **Goal:** Enable authorized admins to upload books/khutbas and manage events/groups directly within the app via a protected `/admin` route.
> **Architecture:** Flutter Web (Admin Dashboard) + Supabase (Auth, DB, Storage).

---

## Phase 1: Foundation & Security
**Agent:** `security-auditor`

- [ ] **Database Schema:** Create Supabase tables with RLS policies.
    - `books` (id, title, author, category, file_url, cover_url, created_by)
    - `khutbas` (id, title, speaker, date, audio_url, created_by)
    - `categories` (id, name, type)
- [ ] **Storage Buckets:**
    - `library_files` (PDFs, EPUBs, MP3s) - Authenticated read? Or Public read, Admin write.
    - `covers` (Images) - Public read.
- [ ] **Role Management:**
    - Ensure `profiles` table has `is_admin` boolean or `role` enum.
    - Write RLS policies: `is_admin` required for INSERT/UPDATE/DELETE.
- [ ] **Route Guard:**
    - Create `AdminGuard` in `app_router.dart` to redirect non-admins.
    - Add `/admin` route with `AdminDashboardScreen`.

## Phase 2: Data Layer Upgrade
**Agent:** `backend-specialist`

- [ ] **Supabase Integration:**
    - Update `LibraryService` to fetch from Supabase `books` table instead of/in addition to Hive local storage.
    - Implement "Sync" logic (optional for MVP, or just direct fetch).
- [ ] **Repository Layer:**
    - `AdminRepository` for uploading files and inserting records.
    - Methods: `uploadBook(file, metadata)`, `uploadKhutba(...)`.

## Phase 3: Admin Dashboard UI
**Agent:** `frontend-specialist`

- [ ] **Dashboard Shell:** Sidebar navigation for Admin sections (Library, Community, Users).
- [ ] **Library Manager:**
    - **Upload Form:** Drag & Drop file area (PDF/EPUB).
    - **Metadata Inputs:** Title, Author, Category (dropdown), Description.
    - **List View:** Table of existing items with Edit/Delete actions.
- [ ] **Community Manager:**
    - **Event Creator:** Date picker, location, description.
    - **Group Manager:** Approve/Reject new groups (if applicable).

## Phase 4: Verification & Polish
**Agent:** `quality-assurance`

- [ ] **E2E Test:** Login as Admin -> Upload Book -> Verify in User Library.
- [ ] **Security Test:** Login as User -> Try to access `/admin` -> Verify Redirect.
- [ ] **Performance:** Ensure large PDF uploads show progress indicators.

---

## Agent Assignments

| Domain | Agent | Responsibility |
|--------|-------|----------------|
| **Auth/DB** | `backend-specialist` | Schema, RLS, Storage Setup |
| **UI/UX** | `frontend-specialist` | Admin Dashboard, Forms, File Pickers |
| **Logic** | `orchestrator` | Connecting UI to Repositories |

## Verification Checklist

1. [ ] Admin user can log in and see `/admin`.
2. [ ] Non-admin user is redirected from `/admin`.
3. [ ] Uploading a PDF saves to Storage and creates a DB record.
4. [ ] The new book appears in the main Library tab.
5. [ ] RLS prevents non-admins from writing to `books`.
