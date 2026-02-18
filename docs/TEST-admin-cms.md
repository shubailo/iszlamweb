# Admin CMS Manual Verification Plan

## Prerequisites
1.  **Supabase Project**: Ensure you have a working Supabase project linked.
2.  **Storage Buckets**: Create public buckets: `library_files`, `covers`.
3.  **SQL Schema**: Run `docs/SOL-admin-schema.sql` successfully.

## Test Cases

### 1. Admin Access Control
- [ ] **Scenario**: Non-admin user tries to access `/admin`.
    - **Action**: Log in as normal user. Navigate to `/admin`.
    - **Expected**: Redirected to home `/` with "Access Denied" snackbar.
- [ ] **Scenario**: Admin user accesses `/admin`.
    - **Action**:
        1.  In Supabase Table Editor -> `profiles`, find your user ID.
        2.  Set `is_admin` to `TRUE`.
        3.  Log out and Log back in app.
        4.  Navigate to `/admin`.
    - **Expected**: Admin Dashboard loads successfully.

### 2. Book Upload Flow
- [ ] **Scenario**: Upload a PDF book with cover.
    - **Action**:
        1.  Click "Add New Book".
        2.  Fill Title: "Test Book", Author: "Tester", Category: "General".
        3.  Pick a dummy PDF file.
        4.  Pick a dummy Cover image.
        5.  Click "Upload".
    - **Expected**:
        - Success snackbar.
        - Supabase Storage: File in `library_files`, image in `covers`.
        - Supabase DB: New row in `books` table.

### 3. Library Integration
- [ ] **Scenario**: Verify book appears in app.
    - **Action**:
        1.  Navigate to `Library` tab in the app.
        2.  Refresh (or restart if no pull-to-refresh).
    - **Expected**:
        - "Test Book" appears in the grid.
        - Tapping it opens the reader or details (depending on implementation).

### 4. Khutba Upload Flow
- [ ] **Scenario**: Upload an audio Khutba.
    - **Action**:
        1.  Click "Add Khutba".
        2.  Fill details, pick MP3 file.
        3.  Click "Upload".
    - **Expected**:
        - Success snackbar.
        - Supabase DB: New row in `khutbas`.
