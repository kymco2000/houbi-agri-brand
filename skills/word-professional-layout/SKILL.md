---
name: word-professional-layout
description: "Create or revise professional Word layouts, especially multi-level headings, automatic indexes, tables, captions, and print-stable public-works documents."
---

# Word 專業排版

Use this skill when the user wants a `.docx` created, repaired, standardized, or checked for professional layout. Preserve supplied content and any agency template; do not invent project facts or alter technical meaning.

## Before editing

- Treat the agency's issued format, contract, and approved template as authoritative. If they conflict with the defaults below, follow them.
- Inspect the existing style hierarchy, sections, headers/footers, captions, and tables before changing formatting. Do not use spaces, manual tabs, repeated paragraph marks, or typed page numbers to simulate layout.
- For document artifacts, use the `documents` skill's create/edit and render-and-verify workflow.

## Stable outline defaults

Bind every multi-level list level to its corresponding built-in heading style. Use the following only when the user has no specified format:

| Level | Style | Numbering | Number position | Text indent | After number |
|---|---|---|---:|---:|---|
| 1 | Heading 1 | 第 一 章 | 0 cm | 0 cm | Space |
| 2 | Heading 2 | 第 一 節 | 0 cm | 0 cm | Space |
| 3 | Heading 3 | 壹、貳、參 | 0 cm | 0.9 cm | Tab stop |
| 4 | Heading 4 | 一、二、三 | 0.9 cm | 1.8 cm | Tab stop |
| 5 | Heading 5 | （一）、（二） | 1.8 cm | 2.7 cm | Tab stop |
| 6 | Heading 6 | 1.、2.、3. | 2.7 cm | 3.6 cm | Tab stop |
| 7 | Heading 7 | （1）、（2） | 3.6 cm | 4.5 cm | Tab stop |

Set lower-level numbering to restart under the immediate parent. Use Word Heading styles rather than visually similar manual formatting, so navigation and automatic indexes remain valid.

## Layout conventions

- Default body text: 12 pt, first-line indent of two Chinese characters, with either fixed 22–24 pt line spacing or 1.5 lines consistently throughout a document.
- Default A4 margins: top/bottom 2 cm, left 2.5 cm, right 2 cm. Increase the binding side only when the submission method requires it.
- Use section breaks—not page breaks or empty paragraphs—when page orientation, margins, headers/footers, or page-number formats change.
- Use caption fields for figures and tables and cross-references for every internal citation. Generate tables of contents and figures/tables from fields, not typed page numbers.
- Tables: repeat header rows on subsequent pages; prevent inappropriate row splitting; use 10.5–12 pt text; align data according to meaning; preserve editable cells and borders.
- Anchor figures predictably, retain sufficient resolution, and keep each caption with its figure/table. Use editable Word shapes or SmartArt when the source is meant to be editable.

## Verification before delivery

- Update all fields, including the table of contents, lists of figures/tables, captions, and cross-references.
- Search for `錯誤! 找不到參照來源。`, unresolved REF fields, blank captions, accidental empty pages, clipped tables, and inconsistent page numbering.
- Render the final document to inspect all pages. Report any layout fidelity limitation honestly, especially when the source is a PDF or scan rather than an original DOCX.
