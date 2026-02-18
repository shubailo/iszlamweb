## 🧠 Brainstorm: Transforming PDFs to EPUBs for Better UX

### Context
The current app displays *fixed-layout PDFs*. On mobile screens, this forces users to "pinch-to-zoom" to read small text, which breaks immersion. We want to convert these 11+ books into **EPUB (reflowable text)** format so users can change font size, switch to dark mode, and read comfortably on any device.

---

### Option A: AI-Assisted Extraction & Structuring (The "Modern" Way)
Use an LLM (like Gemini 1.5 Pro or GPT-4o) to process the PDF images/text and output structured Markdown, then compile to EPUB.

✅ **Pros:**
- **High Quality**: Handles headers, footnotes, and Quranic verses (Arabic text) much better than standard OCR.
- **Cleanup**: AI can fix hyphenation issues and remove page numbers/headers automatically.
- **Future-Proof**: The output is clean Semantic HTML/Markdown, usable for web and mobile.

❌ **Cons:**
- **Cost/Time**: Requires processing each book through an AI API or manual copy-paste into a chat window.
- **Verification**: You must proofread to ensure the AI didn't hallucinate or skip sections.

📊 **Effort:** Medium (for 11 books) | **Quality:** High

---

### Option B: Calibre / Manual Conversion Tool (The "DIY" Way)
Use the industry-standard free tool **Calibre** to convert PDF -> EPUB.

✅ **Pros:**
- **Free**: No API costs.
- **Fast**: Click "Convert" and it's done in seconds.
- **Control**: Advanced regex settings to remove headers/footers.

❌ **Cons:**
- **Formatting Nightmares**: PDFs are notorious for "hard line breaks". The EPUB often ends up with broken paragraphs and weird spacing.
- **Complex Layouts**: Fails with sidebars, images, or mixed Arabic/Hungarian text direction.

📊 **Effort:** Low (to start), High (to fix errors) | **Quality:** Low to Medium

---

### Option C: The "Reader Mode" (App-Side Parsing)
Don't create EPUB files. Instead, build a feature in the app that extracts text from the PDF *on the fly* and displays it as a simple text stream (like "Reader View" in browsers).

✅ **Pros:**
- **Zero Prep**: No need to convert files beforehand.
- **Hybrid**: Users can switch between "Original PDF Layout" and "Text View".

❌ **Cons:**
- **Performance**: Heavy processing on the user's device.
- **Accuracy**: Will likely break on complex pages (e.g., poetry, tables).
- **No Offline Polish**: You can't manually fix typos or layout bugs.

📊 **Effort:** High (App Code Complexity) | **Quality:** Variable

---

### Option D: Professional Service / Freelancer (The "Outsource" Way)
Hire a data entry specialist or use a service like "PDF to EPUB" professional conversion.

✅ **Pros:**
- **Perfect Quality**: Human verified.
- **Zero Dev Effort**: You just receive the files.

❌ **Cons:**
- **Cost**: Can cost $0.50 - $2.00 per page.
- **Turnaround Time**: Takes days or weeks.

📊 **Effort:** Ultra Low | **Quality:** Perfect

---

## 💡 Recommendation

**Option A (AI-Assisted Markdown)** is the best fit for 11 books.

**Why?**
1.  **Scale**: 11 books is small enough to process one-by-one but too large to manually retype.
2.  **Quality**: Religious texts often have specific formatting (Arabic/Hungarian mix) that standard converters (Option B) break.
3.  **App Ready**: If we convert them to **Markdown** first, we can render them natively in Flutter using `flutter_markdown` (easier than a full EPUB engine) OR compile them to EPUBs.

**Proposed Workflow:**
1.  I can write a script (or we do it manually) to extract text from a PDF.
2.  We ask an AI to "Clean this text and format as Markdown."
3.  We start by displaying **Markdown** in the app instead of full EPUBs. It's lighter and easier to implement than a full EPUB reader!

What direction would you like to explore?
