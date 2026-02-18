# PLAN: Admin Logic & Functionality Fix

This plan aims to restore all admin capabilities (mosque creation, post creation, group creation, book uploads) by reconciling the Supabase schema with the Flutter application's expectations and ensuring RLS policies are correctly configured.

## User Review Required

> [!IMPORTANT]
> **Clarification Needed on "Admin Logic in Supabase"**
> Does this strictly mean fixing the broken RPC/Tables, or are you looking to implement complex business rules directly in PostgreSQL triggers?

> [!WARNING]
> **Data Loss Risk**
> If the `books` table exists but has a different schema, modifying it might require careful data migration. I will check for existence before application.

## 🎯 Success Criteria
- [ ] Admins can create new Mosques with full metadata (timing, privacy, etc.)
- [ ] Admins can upload books and see them appearing in the catalog.
- [ ] Users (with admin rights) can create community posts.
- [ ] Mosque groups can be created and managed.
- [ ] All `is_admin` checks in RLS are performant and reliable.

## 🛠️ Tech Stack
- **Backend**: Supabase (PostgreSQL, RLS, Storage)
- **Frontend**: Flutter (Riverpod, Supabase SDK)

## 📋 Task Breakdown

### Phase 1: Database Schema Reconcilation (P0)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T1.1 | Fix `mosques` table | `database-architect` | `database-design` | `mosque.dart` → `ALTER TABLE` → `\d mosques` shows all columns |
| T1.2 | Create `books` table | `database-architect` | `database-design` | `book.dart` → `CREATE TABLE` → Table exists in Supabase |
| T1.3 | Create `library_categories` | `database-architect` | `database-design` | `admin_repository.dart` → `CREATE TABLE` → Table exists |
| T1.4 | Fix `community_posts` | `database-architect` | `database-design` | `community_post.dart` → `ALTER TABLE` → Columns added |
| T1.5 | Fix `mosque_groups` | `database-architect` | `database-design` | `mosque_group.dart` → `CREATE/ALTER TABLE` → Table matches model |

### Phase 2: RLS & Permissions Audit (P1)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T2.1 | Optimize `is_admin` | `security-auditor` | `api-patterns` | `profiles` table → Fixed helper function → No recursion errors |
| T2.2 | Fix Admin Policies | `security-auditor` | `api-patterns` | Policies for all tables → Updated SQL → Successful `INSERT` in tests |
| T2.3 | Storage Policies | `security-auditor` | `api-patterns` | `library_files` bucket → Policy update → Successful file upload |

### Phase 3: Flutter Service Verification (P2)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T3.1 | Test Mosque Creation | `mobile-developer` | `mobile-design` | Create Dialog → Click Save → No 400 error |
| T3.2 | Test Book Upload | `mobile-developer` | `mobile-design` | Admin Screen → Upload PDF → Book appears in list |
| T3.3 | Test Community Post | `mobile-developer` | `mobile-design` | Post Dialog → Submit → Post visible in feed |

## 🧪 Phase X: Final Verification
- [ ] Run `python .agent/scripts/verify_all.py`
- [ ] Verify no 400 Bad Request errors in browser console during admin actions.
- [ ] Confirm file visibility in Supabase Storage after upload.
