-- Migration: Enhance Community Schema for Reddit-style Features
-- Date: 2026-02-18

-- 1. Update community_posts table
ALTER TABLE community_posts 
ADD COLUMN IF NOT EXISTS post_type TEXT NOT NULL DEFAULT 'text',
ADD COLUMN IF NOT EXISTS link_url TEXT,
ADD COLUMN IF NOT EXISTS poll_options JSONB,
ADD COLUMN IF NOT EXISTS poll_votes JSONB;

-- 2. Update mosques table
ALTER TABLE mosques 
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS privacy_type TEXT NOT NULL DEFAULT 'public';

-- 3. Update mosque_groups table
-- Note: Re-creating mosque_groups with more robust fields if needed, 
-- or just altering columns if it exists.
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'mosque_groups') THEN
        ALTER TABLE mosque_groups 
        ADD COLUMN IF NOT EXISTS privacy_type TEXT NOT NULL DEFAULT 'public',
        ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now(),
        ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now();
    ELSE
        CREATE TABLE mosque_groups (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            mosque_id UUID REFERENCES mosques(id) ON DELETE CASCADE,
            name TEXT NOT NULL,
            description TEXT,
            leader_name TEXT,
            meeting_time TEXT,
            image_url TEXT,
            privacy_type TEXT NOT NULL DEFAULT 'public',
            created_at TIMESTAMPTZ DEFAULT now(),
            updated_at TIMESTAMPTZ DEFAULT now()
        );
    END IF;
END $$;

-- 4. Enable RLS (Ensure only admins can create mosques and groups)
-- (Assuming profiles table has is_admin column)

-- Policy for mosques (All can see public, only authenticated can join)
-- Policy for posts (Everyone in the mosque can see)

-- Indexing for performance
CREATE INDEX IF NOT EXISTS idx_community_posts_mosque_id ON community_posts(mosque_id);
CREATE INDEX IF NOT EXISTS idx_mosque_groups_mosque_id ON mosque_groups(mosque_id);
