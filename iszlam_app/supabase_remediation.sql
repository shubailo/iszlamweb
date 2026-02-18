-- Supabase RLS Optimization Script (v3: Corrected PostgreSQL Syntax)
-- This script fixes "auth_rls_initplan" (performance) and "multiple_permissive_policies" (overlap) warnings.

-- 1. MOSQUES: Optimize Admin Policies
DROP POLICY IF EXISTS "Allow only admins to manage mosques" ON public.mosques;
DROP POLICY IF EXISTS "Allow only admins to insert mosques" ON public.mosques;
DROP POLICY IF EXISTS "Allow only admins to update mosques" ON public.mosques;
DROP POLICY IF EXISTS "Allow only admins to delete mosques" ON public.mosques;
DROP POLICY IF EXISTS "Allow public read-only access to mosques" ON public.mosques;

-- Public/Authenticated Read Policy
CREATE POLICY "Allow public read-only access to mosques" ON public.mosques
  FOR SELECT
  USING (true);

-- Admin Management (Separated by action to fix syntax error)
CREATE POLICY "Allow only admins to insert mosques" ON public.mosques
  FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);

CREATE POLICY "Allow only admins to update mosques" ON public.mosques
  FOR UPDATE
  TO authenticated
  USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);

CREATE POLICY "Allow only admins to delete mosques" ON public.mosques
  FOR DELETE
  TO authenticated
  USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);


-- 2. COMMUNITY POSTS: Optimize and Resolve Overlaps
DROP POLICY IF EXISTS "Allow only admins to manage posts" ON public.community_posts;
DROP POLICY IF EXISTS "Allow only admins to insert posts" ON public.community_posts;
DROP POLICY IF EXISTS "Allow only admins to update posts" ON public.community_posts;
DROP POLICY IF EXISTS "Allow only admins to delete posts" ON public.community_posts;
DROP POLICY IF EXISTS "Allow public read-only access to posts" ON public.community_posts;

-- Public/Authenticated Read Policy
CREATE POLICY "Allow public read-only access to posts" ON public.community_posts
  FOR SELECT
  USING (true);

-- Admin Management
CREATE POLICY "Allow only admins to insert posts" ON public.community_posts
  FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);

CREATE POLICY "Allow only admins to update posts" ON public.community_posts
  FOR UPDATE
  TO authenticated
  USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);

CREATE POLICY "Allow only admins to delete posts" ON public.community_posts
  FOR DELETE
  TO authenticated
  USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);


-- 3. COMMUNITY VOTES: Optimize and Resolve Overlaps
DROP POLICY IF EXISTS "Allow users to see votes" ON public.community_votes;
DROP POLICY IF EXISTS "Allow users to manage own votes" ON public.community_votes;
DROP POLICY IF EXISTS "Allow users to insert own votes" ON public.community_votes;
DROP POLICY IF EXISTS "Allow users to update own votes" ON public.community_votes;
DROP POLICY IF EXISTS "Allow users to delete own votes" ON public.community_votes;

-- Public/Authenticated Read Policy
CREATE POLICY "Allow users to see votes" ON public.community_votes
  FOR SELECT
  USING (true);

-- Owner Management
CREATE POLICY "Allow users to insert own votes" ON public.community_votes
  FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "Allow users to update own votes" ON public.community_votes
  FOR UPDATE
  TO authenticated
  USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "Allow users to delete own votes" ON public.community_votes
  FOR DELETE
  TO authenticated
  USING ((SELECT auth.uid()) = user_id);


-- 4. COMMUNITY COMMENTS: Optimize
DROP POLICY IF EXISTS "Allow users to create comments" ON public.community_comments;
DROP POLICY IF EXISTS "Allow users to delete own comments" ON public.community_comments;

CREATE POLICY "Allow users to create comments" ON public.community_comments
  FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "Allow users to delete own comments" ON public.community_comments
  FOR DELETE
  TO authenticated
  USING ((SELECT auth.uid()) = user_id);


-- 5. ASMAUL HUSNA: Optimize and Resolve Overlaps
DROP POLICY IF EXISTS "Admin Manage Asmaul Husna" ON public.asmaul_husna;
DROP POLICY IF EXISTS "Admin Insert Asmaul Husna" ON public.asmaul_husna;
DROP POLICY IF EXISTS "Admin Update Asmaul Husna" ON public.asmaul_husna;
DROP POLICY IF EXISTS "Admin Delete Asmaul Husna" ON public.asmaul_husna;
DROP POLICY IF EXISTS "Public Read Asmaul Husna" ON public.asmaul_husna;

CREATE POLICY "Public Read Asmaul Husna" ON public.asmaul_husna
  FOR SELECT
  USING (true);

CREATE POLICY "Admin Insert Asmaul Husna" ON public.asmaul_husna
  FOR INSERT TO authenticated WITH CHECK ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);
CREATE POLICY "Admin Update Asmaul Husna" ON public.asmaul_husna
  FOR UPDATE TO authenticated USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);
CREATE POLICY "Admin Delete Asmaul Husna" ON public.asmaul_husna
  FOR DELETE TO authenticated USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);


-- 6. DUA CATEGORIES: Optimize and Resolve Overlaps
DROP POLICY IF EXISTS "Admin Manage Dua Categories" ON public.dua_categories;
DROP POLICY IF EXISTS "Admin Insert Dua Categories" ON public.dua_categories;
DROP POLICY IF EXISTS "Admin Update Dua Categories" ON public.dua_categories;
DROP POLICY IF EXISTS "Admin Delete Dua Categories" ON public.dua_categories;
DROP POLICY IF EXISTS "Public Read Dua Categories" ON public.dua_categories;

CREATE POLICY "Public Read Dua Categories" ON public.dua_categories
  FOR SELECT
  USING (true);

CREATE POLICY "Admin Insert Dua Categories" ON public.dua_categories
  FOR INSERT TO authenticated WITH CHECK ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);
CREATE POLICY "Admin Update Dua Categories" ON public.dua_categories
  FOR UPDATE TO authenticated USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);
CREATE POLICY "Admin Delete Dua Categories" ON public.dua_categories
  FOR DELETE TO authenticated USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);


-- 7. DUAS: Optimize and Resolve Overlaps
DROP POLICY IF EXISTS "Admin Manage Duas" ON public.duas;
DROP POLICY IF EXISTS "Admin Insert Duas" ON public.duas;
DROP POLICY IF EXISTS "Admin Update Duas" ON public.duas;
DROP POLICY IF EXISTS "Admin Delete Duas" ON public.duas;
DROP POLICY IF EXISTS "Public Read Duas" ON public.duas;

CREATE POLICY "Public Read Duas" ON public.duas
  FOR SELECT
  USING (true);

CREATE POLICY "Admin Insert Duas" ON public.duas
  FOR INSERT TO authenticated WITH CHECK ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);
CREATE POLICY "Admin Update Duas" ON public.duas
  FOR UPDATE TO authenticated USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);
CREATE POLICY "Admin Delete Duas" ON public.duas
  FOR DELETE TO authenticated USING ((SELECT is_admin FROM profiles WHERE id = (SELECT auth.uid())) = true);


-- 8. SECURITY: Fix Search Path for Functions
-- This prevents search path hijacking by locking the function to the 'public' schema.
ALTER FUNCTION public.handle_vote_score() SET search_path = public;
ALTER FUNCTION public.handle_comment_count() SET search_path = public;

-- NOTE: "Leaked Password Protection Disabled" (Security Lint) 
-- This is a Supabase Auth setting. 
-- Go to: Dashboard -> Auth -> Providers -> Email -> Password Strength
-- Then ENABLE "Check for leaked passwords".
