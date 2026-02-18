# PLAN: Dual-Source Reader (Google Books Experience)

This plan implements a hybrid reading system where books can be viewed as flowing text (EPUB) or original pages (PDF), matching the premium experience of Google Books.

## 🎯 Success Criteria
- [ ] Database schema updated to support separate `epub_url` and `pdf_url` (currently `file_url`).
- [ ] Admin panel supports uploading both EPUB and PDF files for a single book.
- [ ] EPUB is the default reading format for a seamless mobile experience.
- [ ] Users can toggle between "Flowing View" (EPUB) and "Original View" (PDF) in settings.
- [ ] PDF download is available from the reader's internal menu.

## 🛠️ Tech Stack
- **EPUB Engine**: `flutter_epub_viewer` (based on Epub.js for high fidelity).
- **PDF Engine**: `pdfrx` (already integrated).
- **Storage**: Supabase Storage (`library_files` bucket).

## 📋 Task Breakdown

### Phase 1: Foundation & Schema (P0)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T1.1 | Update DB Schema | `database-architect` | `database-design` | Add `epub_url` to `books` table; migrate `file_url` data if needed. |
| T1.2 | Update Models | `mobile-developer` | `clean-code` | Add `epubUrl` to `Book` and `AdminBook` models. |

### Phase 2: Admin Tooling (P1)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T2.1 | Dual File Upload | `mobile-developer` | `clean-code` | Update `AdminUploadBookScreen` with two separate file pickers & upload logic. |
| T2.2 | Migration Helper | `mobile-developer` | `clean-code` | Add a visual indicator in Admin List for books missing an EPUB version. |

### Phase 3: The Hybrid Reader (P2)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T3.1 | Integrate EPUB Viewer | `mobile-developer` | `react-best-practices` | Implement `EpubReaderScreen` using `flutter_epub_viewer`. |
| T3.2 | Create "Google Switcher" | `mobile-developer` | `frontend-design` | Implement routing logic in `LibraryItemCard` and a toggle in reader settings. |
| T3.3 | Add PDF Download | `mobile-developer` | `clean-code` | Add "Download PDF" action to the reader's top menu using `url_launcher`. |

## 🧪 Phase X: Final Verification
- [ ] Upload one PDF and one EPUB for the same book.
- [ ] Verify EPUB opens by default and allows font resizing.
- [ ] Verify switching to "Original View" successfully loads the PDF.
- [ ] Verify PDF download starts successfully from the menu.
- [ ] Ensure older books (PDF-only) still load correctly in the PDF viewer.
