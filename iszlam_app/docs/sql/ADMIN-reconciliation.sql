-- ADMIN RECONCILIATION SCRIPT (Architect Verified v2)
-- Reconciles database schema with Flutter models to fix admin functionality.
-- Optimization focus: Performance indexes, integrity constraints, and automatic timestamping.

-- 0. Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. UTILITIES: Shared triggers
CREATE OR REPLACE FUNCTION public.set_current_timestamp_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. PROFILES: Ensure admin and user fields exist
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS is_admin BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS full_name TEXT;

-- 3. ADMIN HELPER: High-performance is_admin check
-- Optimized with (SELECT auth.uid()) for initplan performance in Supabase
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = (SELECT auth.uid()) 
    AND is_admin = true
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- 4. MOSQUES: Sync columns and performance
ALTER TABLE public.mosques 
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS privacy_type TEXT NOT NULL DEFAULT 'public',
ADD COLUMN IF NOT EXISTS timing JSONB,
ADD COLUMN IF NOT EXISTS room_key TEXT,
ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;

-- 5. LIBRARY CATEGORIES
CREATE TABLE IF NOT EXISTS public.library_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    label_hu TEXT NOT NULL,
    slug TEXT UNIQUE,
    type TEXT CHECK (type IN ('book', 'audio', 'both')),
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. BOOKS
CREATE TABLE IF NOT EXISTS public.books (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    author TEXT,
    description TEXT,
    category_id UUID REFERENCES public.library_categories(id) ON DELETE SET NULL,
    file_url TEXT,
    cover_url TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Index for category-based filtering (Library UI)
CREATE INDEX IF NOT EXISTS idx_books_category_id ON public.books(category_id);

-- 7. KHUTBAS (Audios)
CREATE TABLE IF NOT EXISTS public.khutbas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    speaker TEXT,
    date DATE,
    category_id UUID REFERENCES public.library_categories(id) ON DELETE SET NULL,
    audio_url TEXT,
    description TEXT,
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Index for date-based ordering and category filtering
CREATE INDEX IF NOT EXISTS idx_khutbas_date ON public.khutbas(date DESC);
CREATE INDEX IF NOT EXISTS idx_khutbas_category_id ON public.khutbas(category_id);

-- 8. COMMUNITY POSTS: Sync columns
ALTER TABLE public.community_posts 
ADD COLUMN IF NOT EXISTS post_type TEXT NOT NULL DEFAULT 'text',
ADD COLUMN IF NOT EXISTS link_url TEXT,
ADD COLUMN IF NOT EXISTS poll_options JSONB,
ADD COLUMN IF NOT EXISTS poll_votes JSONB;

-- Performance index for feed loading
CREATE INDEX IF NOT EXISTS idx_community_posts_mosque_id_created ON public.community_posts(mosque_id, created_at DESC);

-- 9. MOSQUE GROUPS
CREATE TABLE IF NOT EXISTS public.mosque_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mosque_id UUID REFERENCES public.mosques(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    leader_name TEXT,
    meeting_time TEXT,
    image_url TEXT,
    privacy_type TEXT NOT NULL DEFAULT 'public',
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Index for mosque groups
CREATE INDEX IF NOT EXISTS idx_mosque_groups_mosque_id ON public.mosque_groups(mosque_id);

-- Automated timestamp trigger
DROP TRIGGER IF EXISTS on_mosque_groups_update ON public.mosque_groups;
CREATE TRIGGER on_mosque_groups_update
    BEFORE UPDATE ON public.mosque_groups
    FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();

-- 10. RLS ENABLEMENT
ALTER TABLE public.library_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.khutbas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mosque_groups ENABLE ROW LEVEL SECURITY;

-- 11. POLICIES (Admin Optimized)

-- Clean up existing to avoid conflicts
DO $$ 
BEGIN
    -- Library Categories
    DROP POLICY IF EXISTS "Public Read Categories" ON public.library_categories;
    DROP POLICY IF EXISTS "Admin Manage Categories" ON public.library_categories;
    
    -- Books
    DROP POLICY IF EXISTS "Public Read Books" ON public.books;
    DROP POLICY IF EXISTS "Admin Manage Books" ON public.books;
    
    -- Khutbas
    DROP POLICY IF EXISTS "Public Read Khutbas" ON public.khutbas;
    DROP POLICY IF EXISTS "Admin Manage Khutbas" ON public.khutbas;
    
    -- Mosque Groups
    DROP POLICY IF EXISTS "Public Read Groups" ON public.mosque_groups;
    DROP POLICY IF EXISTS "Admin Manage Groups" ON public.mosque_groups;
END $$;

-- Apply Optimized Policies
CREATE POLICY "Public Read Categories" ON public.library_categories FOR SELECT USING (true);
CREATE POLICY "Admin Manage Categories" ON public.library_categories FOR ALL TO authenticated USING (public.is_admin());

CREATE POLICY "Public Read Books" ON public.books FOR SELECT USING (true);
CREATE POLICY "Admin Manage Books" ON public.books FOR ALL TO authenticated USING (public.is_admin());

CREATE POLICY "Public Read Khutbas" ON public.khutbas FOR SELECT USING (true);
CREATE POLICY "Admin Manage Khutbas" ON public.khutbas FOR ALL TO authenticated USING (public.is_admin());

CREATE POLICY "Public Read Groups" ON public.mosque_groups FOR SELECT USING (true);
CREATE POLICY "Admin Manage Groups" ON public.mosque_groups FOR ALL TO authenticated USING (public.is_admin());

-- 12. STORAGE BUCKETS POLICIES Refinement (Reference Implementation)
-- ensure library_files and covers buckets exist and have public access.
-- Requires storage extensions to be active.

-- create policy "Public Access" on storage.objects for select using ( bucket_id IN ('library_files', 'covers') );
-- create policy "Admin Upload" on storage.objects for insert with check ( bucket_id IN ('library_files', 'covers') AND public.is_admin() );
