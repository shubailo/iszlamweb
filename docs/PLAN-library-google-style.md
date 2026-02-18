# Plan: Google Books-Style Library (Unified Archive)

> **Goal:** Create a unified, searchable library interface for Books (PDF/EPUB) and Audio (Khutbas), featuring robust categorization and filtering, similar to Google Play Books.

## 0. Socratic Gate & Open Questions
Before finalizing the implementation, we need to clarify a few architectural details. I have made **Working Assumptions** for this plan, please confirm/correct them:

| Question | Working Assumption | Implication |
| :--- | :--- | :--- |
| **Audio Source** | Local files (like PDFs) or direct Downloads. | We need a "Import Audio" feature similar to "Import PDF". |
| **Metadata** | Users manually edit Title/Author/Category after import. | We need an "Edit Details" dialog for valid sorting/filtering. |
| **Categories** | Fixed list (Fiqh, History, Aqidah, etc.) + "Uncategorized". | Easier for v1 than dynamic user-created tags. |
| **EPUB Support** | Not in v1, but architecture must support it. | `Book` model will have a `format` enum (PDF, EPUB, AUDIO). |

---

## 1. Architecture & Data Model

We need a unified `LibraryItem` model (or update `Book` to be more generic) to support both readable and listenable content.

### Data Scheme (Hive)
Update `Book` model to support:
- `id` (UUID)
- `title` (String)
- `author` (String)
- `type` (Enum: `book`, `audio`)
- `format` (Enum: `pdf`, `epub`, `mp3`)
- `category` (Enum/String: `worship`, `history`, `fiqh`, `general`)
- `addedAt` (DateTime)
- `path` (String - local file path)
- `coverPath` (String? - generated thumbnail)

### Store/Providers
- `LibraryProvider`: Manages the list of all items.
- `FilterProvider`: Manages current search query and active filters.
  - `searchQuery`: String
  - `categoryFilter`: Set<String>
  - `typeFilter`: Set<LibraryType> (Books vs Audio)

---

## 2. UI/UX Design (The "Unified Archive")

### Core Layout (`LibraryScreen`)
1.  **Top Bar (Pinned):**
    -   **Search Field:** Large, rounded text field. "Search title, author..."
    -   **Filter Row:** Horizontal scrollable chips.
        -   `[All]` `[Books]` `[Khutbas]` `[ | ]` `[History]` `[Fiqh]` `[Worship]`
2.  **Body Content:**
    -   **Grid View (Default):**
        -   Items displayed as cards.
        -   **Visual Distinction:**
            -   **Books:** Vertical aspect ratio (cover).
            -   **Audio:** Square or Landscape aspect ratio (waveform/icon).
    -   **Empty State:** "No items found for '[query]'" with "Clear Filters" button.
3.  **Floating Action Button:**
    -   `[+] Add New` -> Expands to `[Import Book]` and `[Import Audio]`.

### Interactions
-   **Tap Item:**
    -   **Book:** Opens `BookReaderScreen`.
    -   **Audio:** Opens `AudioPlayerSheet` (Persistent bottom sheet?) or `AudioPlayerScreen`.
-   **Long Press:**
    -   Context menu: `Edit Details`, `Delete`, `Share`.

---

## 3. Implementation Phases

### Phase 1: Data Model & State
- [ ] Refactor `Book` model to `LibraryItem` (or expand `Book`).
- [ ] Update Hive boxes and adapters.
- [ ] Implement `LibraryFilterNotifier` for logic.

### Phase 2: UI Skeleton & Navigation
- [ ] Create `LibrarySearchAppBar`.
- [ ] Create `LibraryFilterChips`.
- [ ] Build the `LibraryGrid` with dummy data.

### Phase 3: Search & Filter Logic
- [ ] Connect Search Bar to `FilterProvider`.
- [ ] Connect Chips to `FilterProvider`.
- [ ] Implement efficient filtering logic in the provider (local filtering is fast).

### Phase 4: Import & Metadata
- [ ] Update `FAB` to support multiple file types (PDF, MP3).
- [ ] Create `EditMetadataDialog` (vital for "Author" and "Category" since files don't have this).

---

## 4. Verification Plan

### Automated Tests
-   **Unit:** Test filtering logic (e.g., "Search 'Fiqh' returns only Fiqh items").
-   **Widget:** Test Search Bar input updates the state.

### Manual Verification
1.  Import a PDF -> Ensure it appears under "All" and "Books".
2.  Import an MP3 -> Ensure it appears under "All" and "Khutbas".
3.  Search for "Allah" -> Ensure matches in both types appear.
4.  Filter by "History" -> Ensure only History items appear.
