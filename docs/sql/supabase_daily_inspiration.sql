-- Daily Inspiration Migration (Hadith/Quran)

-- 1. Create table
CREATE TABLE IF NOT EXISTS public.daily_inspiration (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type TEXT NOT NULL CHECK (type IN ('quran', 'hadith', 'quote', 'video')),
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    source TEXT NOT NULL,
    image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Enable RLS
ALTER TABLE public.daily_inspiration ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies
-- Anyone can see active inspirations
CREATE POLICY "Allow public read access to active inspiration" ON public.daily_inspiration
    FOR SELECT USING (is_active = true);

-- Only admins can manage inspiration
CREATE POLICY "Allow admins to manage daily_inspiration" ON public.daily_inspiration
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND is_admin = true
        )
    );

-- 4. Sample Data
INSERT INTO public.daily_inspiration (type, title, body, source)
VALUES 
    ('quran', 'Surah Al-Baqarah, 2:186', 'And when My servants ask you, [O Muhammad], concerning Me - indeed I am near.', 'The Holy Quran'),
    ('hadith', 'Sahih Bukhari', 'The best among you are those who have the best manners and character.', 'Prophet Muhammad (PBUH)')
ON CONFLICT DO NOTHING;
