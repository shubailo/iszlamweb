# PLAN: Community Admin & Reddit-style Upgrade

Implementing comprehensive admin capabilities for the Community feature, featuring a Reddit-style post creation flow and management for communities (mosques) and sub-groups.

## 🎯 Goal
Empower admins to manage the "Digital Sanctuary" community by adding posts (Reddit-style), events, sub-groups, and new communities, while maintaining a consistent and premium UI.

## 🏗️ Phase -1: Context Check
- **Codebase**: Flutter/Dart using Supabase for backend and Riverpod for state management.
- **Current State**: Community feed exists but lacks advanced post types and in-app admin creation tools.
- **Reference**: `references/Reddit-Clone` (React) provides the UX blueprint for post tabs and community structure.
- **Constraint**: Must adhere to `GardenPalette` (no purple, premium aesthetics).

## 🛑 Phase 0: Socratic Gate

> [!NOTE]
> Based on previous clarifications:
> - **Top Bar**: We will implement a "Create Post" bar at the very top of the feed for admins.
> - **Post Types**: Support for Text, Image, Link, and Polls is required.
> - **Structure**: Community (Mosque) -> Groups (e.g., Quran Circle).

**Final Edge Case Questions:**
1. **Poll Storage**: Should poll results be real-time or updated on refresh?
2. **Community Creation**: Should admins be able to upload a community logo/banner during creation, or is that a separate "Edit" task?

## 📋 Phase 1: Task Breakdown

### 1. Data Layer & Schema (Agent: @backend-specialist)
- [ ] Create Supabase migration for `community_posts` (add `post_type`, `link_url`, `poll_data`).
- [ ] Create Supabase migration for `mosque_groups` and `mosques` tables.
- [ ] Update `CommunityPost`, `Mosque`, and `MosqueGroup` Dart models.
- [ ] Enhance `CommunityService` with `createGroup`, `createMosque`, and `votePoll` methods.

### 2. UI Components (Agent: @frontend-specialist)
- [ ] **CreatePostBar**: Implement the Reddit-style top bar for the feed.
- [ ] **Multi-Tab Post Form**:
    - [ ] Tab 1: Text Post (Title + Markdown Body).
    - [ ] Tab 2: Image Post (File picker with preview).
    - [ ] Tab 3: Link Post (URL validation).
    - [ ] Tab 4: Poll Post (Dynamic option adding).
- [ ] **Admin Dialogs**: Design premium forms for Community and Group creation.

### 3. Navigation & States (Agent: @orchestrator)
- [ ] Update `CommunitySidebar` to include "Create Community" and "Create Group" actions for admins.
- [ ] Hook up `isAdminProvider` to toggle administrative UI visibility.
- [ ] Ensure automatic linking to the `selectedMosqueId`.

## 🧪 Phase 2: Verification

### Automated
- [ ] Unit tests for `poll_data` JSON parsing.
- [ ] Integration tests for `CommunityService.createPost`.

### Manual
- [ ] Verify image upload flow to Supabase Storage.
- [ ] Test poll voting logic with multiple accounts (mocked).
- [ ] UI Audit: Ensure "no purple" and "premium" feel.

---

## 👥 Agent Assignments
- **Orchestrator**: Routing and integration.
- **Frontend Specialist**: CreatePostBar, Multi-tab Form, Admin Dialogs.
- **Backend Specialist**: Supabase migrations, Service methods, Data models.
