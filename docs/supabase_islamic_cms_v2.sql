-- Extended Islamic Content Migration v2 (Inline Admin Edition)

-- 1. Asmaul Husna (99 Names of Allah)
CREATE TABLE IF NOT EXISTS public.asmaul_husna (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    number INTEGER NOT NULL UNIQUE,
    arabic TEXT NOT NULL,
    transliteration TEXT NOT NULL,
    meaning_hu TEXT NOT NULL,
    description_hu TEXT, -- "Mit jelent?"
    origin_hu TEXT,      -- "Eredet"
    mentions_hu TEXT,    -- "Említések a Koránban"
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Dua Categories
CREATE TABLE IF NOT EXISTS public.dua_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_hu TEXT NOT NULL,
    icon_name TEXT DEFAULT 'menu_book',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Duas (Supplications)
CREATE TABLE IF NOT EXISTS public.duas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES public.dua_categories(id) ON DELETE CASCADE,
    title_hu TEXT NOT NULL,
    arabic_text TEXT NOT NULL,
    vocalized_text TEXT,
    translation_hu TEXT,
    reference TEXT,
    repeat_count INTEGER DEFAULT 1,
    audio_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Enable RLS
ALTER TABLE public.asmaul_husna ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dua_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duas ENABLE ROW LEVEL SECURITY;

-- 5. Policies
-- Public Read
CREATE POLICY "Public Read Asmaul Husna" ON public.asmaul_husna FOR SELECT USING (true);
CREATE POLICY "Public Read Dua Categories" ON public.dua_categories FOR SELECT USING (true);
CREATE POLICY "Public Read Duas" ON public.duas FOR SELECT USING (true);

-- Admin Manage
CREATE POLICY "Admin Manage Asmaul Husna" ON public.asmaul_husna FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
);
CREATE POLICY "Admin Manage Dua Categories" ON public.dua_categories FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
);
CREATE POLICY "Admin Manage Duas" ON public.duas FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
);
