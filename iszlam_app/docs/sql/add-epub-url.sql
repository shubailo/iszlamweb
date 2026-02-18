-- Migration: Add epub_url column to books table
-- This enables dual-source reading (EPUB for flowing text, PDF for original pages)

ALTER TABLE books ADD COLUMN IF NOT EXISTS epub_url TEXT;

-- Existing file_url remains as the PDF URL.
-- epub_url stores the EPUB version for flowing-text reading.

COMMENT ON COLUMN books.epub_url IS 'URL of the EPUB version for flowing-text reading';
COMMENT ON COLUMN books.file_url IS 'URL of the PDF version for original-page reading and downloads';
