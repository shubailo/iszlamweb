# PLAN: Islamic Features Upgrade

This plan outlines the steps to upgrade the Tasbih feature and implement a dynamic Daily Inspiration module managed via Supabase.

## User Review Required

> [!IMPORTANT]
> - **Supabase Data**: Admin will need to manually populate the `daily_inspiration` table after migration.
> - **Navigation Change**: The `QuickToolsRow` on the Home Screen will be removed. Tools will move to the Sidebar.

## Proposed Changes

---

### 🗄️ Database (Supabase)

#### [NEW] [daily_inspiration_migration.sql](file:///c:/Users/shuba/Desktop/iszlamweb_app/docs/supabase_daily_inspiration.sql)
- Create `daily_inspiration` table with fields: `id`, `type` (enum), `title`, `body`, `source`, `is_active`, `created_at`.
- Enable RLS: `SELECT` for all, `ALL` for admins only.

---

### 🏗️ Flutter Data Layer

#### [MODIFY] [daily_content.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/home/models/daily_content.dart)
- Add `fromJson` and `toJson` methods to support Supabase mapping.

#### [MODIFY] [home_providers.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/home/providers/home_providers.dart)
- Update `dailyContentProvider` to fetch the latest active entry from Supabase.

---

### 🎨 UI Implementation

#### [MODIFY] [tasbih_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/tools/screens/tasbih_screen.dart)
- Overhaul UI for a more "premium" feel (Glassmorphism, smooth animations).
- Retain digital counter logic as requested.
- Use `GardenPalette` consistently.

#### [MODIFY] [daily_wisdom_hero.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/home/widgets/daily_wisdom_hero.dart)
- Integrate a live **Hijri Date** display (calculated locally).
- Display real Hadith/Quran content from Supabase.

#### [MODIFY] [community_sidebar.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/community/widgets/community_sidebar.dart)
- Add a "SEGÉDESZKÖZÖK" (Tools) section.
- Include links to Tasbih, Islamic Calendar, and Qibla Compass.

---

### 🧹 Cleanup

#### [MODIFY] [home_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/home/screens/home_screen.dart)
- Remove `QuickToolsRow`.

---

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no regressions.

### Manual Verification
- Verify admin can insert new inspiration in Supabase and it reflects on the Hero section.
- Check Sidebar navigation on both Mobile (Drawer) and Desktop.
- Ensure Tasbih count persists via SharedPreferences.
