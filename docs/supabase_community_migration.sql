-- 0. Create Mosques Table (Missing in initial run)
CREATE TABLE IF NOT EXISTS public.mosques (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    address TEXT,
    city TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 1. Create Community Posts Table
CREATE TABLE IF NOT EXISTS public.community_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mosque_id UUID REFERENCES public.mosques(id) ON DELETE CASCADE,
    creator_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    content TEXT,
    image_url TEXT,
    audio_url TEXT,
    vote_score INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Create Community Votes Table (Reddit-style)
CREATE TABLE IF NOT EXISTS public.community_votes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    post_id UUID REFERENCES public.community_posts(id) ON DELETE CASCADE,
    vote_value INTEGER CHECK (vote_value IN (1, -1)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(user_id, post_id)
);

-- 3. Create Community Comments Table (Threaded)
CREATE TABLE IF NOT EXISTS public.community_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID REFERENCES public.community_posts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES public.community_comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.mosques ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_comments ENABLE ROW LEVEL SECURITY;

-- 5. RLS Policies for Mosques
CREATE POLICY "Allow public read-only access to mosques" ON public.mosques
    FOR SELECT USING (true);

CREATE POLICY "Allow only admins to manage mosques" ON public.mosques
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND is_admin = true
        )
    );

-- 6. RLS Policies for Posts
-- Anyone can see posts
CREATE POLICY "Allow public read-only access to posts" ON public.community_posts
    FOR SELECT USING (true);

-- Only admins can Create/Update/Delete posts
CREATE POLICY "Allow only admins to manage posts" ON public.community_posts
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND is_admin = true
        )
    );

-- 7. RLS Policies for Votes
-- Logged in users can see votes
CREATE POLICY "Allow users to see votes" ON public.community_votes
    FOR SELECT USING (auth.role() = 'authenticated');

-- Logged in users can manage their own votes
CREATE POLICY "Allow users to manage own votes" ON public.community_votes
    FOR ALL USING (auth.uid() = user_id);

-- 8. RLS Policies for Comments
-- Anyone can see comments
CREATE POLICY "Allow public read access to comments" ON public.community_comments
    FOR SELECT USING (true);

-- Logged in users can create comments
CREATE POLICY "Allow users to create comments" ON public.community_comments
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Users can delete their own comments
CREATE POLICY "Allow users to delete own comments" ON public.community_comments
    FOR DELETE USING (auth.uid() = user_id);

-- 9. Sample Data
INSERT INTO public.mosques (name, address, city)
VALUES 
    ('Budapest Grand Mosque', 'Fehérvári út 45', 'Budapest'),
    ('Debrecen Islamic Center', 'Piac utca 20', 'Debrecen')
ON CONFLICT DO NOTHING;

-- 8. Functions & Triggers for Automatic Counters (Optional but Peer-Recommended)

-- Function to handle vote score updates
CREATE OR REPLACE FUNCTION handle_vote_score() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE public.community_posts 
        SET vote_score = vote_score + NEW.vote_value 
        WHERE id = NEW.post_id;
    ELSIF (TG_OP = 'UPDATE') THEN
        UPDATE public.community_posts 
        SET vote_score = vote_score - OLD.vote_value + NEW.vote_value 
        WHERE id = NEW.post_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE public.community_posts 
        SET vote_score = vote_score - OLD.vote_value 
        WHERE id = OLD.post_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_vote_change
    AFTER INSERT OR UPDATE OR DELETE ON public.community_votes
    FOR EACH ROW EXECUTE FUNCTION handle_vote_score();

-- Function to handle comment count updates
CREATE OR REPLACE FUNCTION handle_comment_count() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE public.community_posts 
        SET comment_count = comment_count + 1 
        WHERE id = NEW.post_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE public.community_posts 
        SET comment_count = comment_count - 1 
        WHERE id = OLD.post_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_comment_change
    AFTER INSERT OR DELETE ON public.community_comments
    FOR EACH ROW EXECUTE FUNCTION handle_comment_count();
