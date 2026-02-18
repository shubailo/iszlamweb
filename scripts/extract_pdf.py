import os
from pypdf import PdfReader

import re

def clean_text(text):
    # Fix hyphenation: "ex-\nample" -> "example"
    text = re.sub(r'(\w+)-\n(\w+)', r'\1\2', text)
    
    # Fix broken lines inside paragraphs: "sentence\n continues" -> "sentence continues"
    # (Simple heuristic: if line ends with lowercase or comma, join it)
    text = re.sub(r'(?<!\n)\n(?!\n)', ' ', text)
    
    # Remove multiple spaces
    text = re.sub(r'\s+', ' ', text)
    
    # Restore paragraph breaks (double newlines were turned into single spaces by above)
    # Actually, pypdf extract_text() usually returns \n for newlines. 
    # Let's adjust: We want to preserve double newlines.
    return text

def extract_text(pdf_path, output_path):
    print(f"Extracting: {pdf_path}")
    reader = PdfReader(pdf_path)
    text = ""
    # Extract ALL pages
    for page in reader.pages:
        page_text = page.extract_text()
        if page_text:
            text += page_text + "\n\n"
    
    # Basic cleaning
    # 1. remove hyphenation at end of lines
    text = re.sub(r'(\w+)-\n(\w+)', r'\1\2', text)
    
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(text)
    print(f"Saved to: {output_path}")

import glob

if __name__ == "__main__":
    books_dir = "iszlam_app/assets/books"
    pdf_files = glob.glob(os.path.join(books_dir, "*.pdf"))
    
    print(f"Found {len(pdf_files)} PDF books.")
    
    for pdf_path in pdf_files:
        filename = os.path.basename(pdf_path)
        output_filename = os.path.splitext(filename)[0] + ".md"
        output_path = os.path.join(books_dir, output_filename)
        
        try:
            extract_text(pdf_path, output_path)
        except Exception as e:
            print(f"Failed to extract {filename}: {e}")
