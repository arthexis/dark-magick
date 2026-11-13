# Poison Chalice — Visual artwork sourcing (pass 1)

Date: 2026-11-12 (Monterrey). Status: **blocked on original image bytes**.

## Scope

- 50 numbered cards (#01–#50) from the original Poison Legacy TTS face sheet.
- The original card *names* are game-specific and **must not** be used to infer the image title or artist.
- Goal: locate the **same artwork**, preferably a clean, higher-resolution publication with an artist attribution and terms of reuse.
- Do not confuse the existing composite card crop with a clean artwork source.
- A visually similar image is **not** an exact source.

## Evidence and current result

- Original face URL and 10×7 layout are preserved in `expansions/poison-legacy.lua`.
- Original 50-card numbering and names are preserved in the Card Creator import CSV.
- Steam's original image endpoint and two known alternative image hosts could not be retrieved through the current research environment.
- Public image searches for the exact Steam image identifier and original deck produced no attributable matching image. Card-name searches produced unrelated items; these are **rejected**, not candidates.
- No source artwork was verified; **0 exact**, **0 probable**, **50 still pending visual comparison**.
- Reuse rights of unknown source artwork are not established.

## Unblocking the visual process

Create numbered reference images (all 50) from a local copy of the original TTS face sheet:

```sh
python -m pip install Pillow
python tools/poison_chalice_extract_reference.py --input "/path/to/poison-legacy-faces.jpg"
```

Alternatively, if the Steam asset URL is accessible on your computer:

```sh
python tools/poison_chalice_extract_reference.py --input-url
```

Output: `build/poison-chalice-visual-reference/card-01.png` through `card-50.png`, `contact-sheet-50.jpg`, and `manifest.json`. Output remains local and uncommitted. These are **full-card reference crops**, not isolated artwork.

## Per-image search and acceptance protocol

1. Inspect the card crop, ignoring title and effect; describe only the visible illustration (subject, colors, composition, pose, symbols).
2. Crop the art frame when safe (avoid card text, borders and symbols); search the crop with Google Lens, Bing Visual Search, TinEye and image-indexed art portfolios.
3. Open candidate source, compare matching composition and distinctive details. Prefer original artist's portfolio or credited publication; record URL, author, full image dimensions and rights/license.
4. Tag `exact_match`, `probable_match`, `false_positive`, `not_found`, or `not_checked`. Do not promote visually similar art to an exact match.
5. Add evidence to a per-card row in the tracker on `feat/poison-chalice-inventory`. Never overwrite original card text or game rules.

## Next batch

Start with #01–#10 once the sprite is visible; use the contact sheet to search in sequential batches until #50. Keep unresolved items visible for later passes. Do not generate substitute artwork without separate authorization.

## Pass 2 — 2026-11-12, 20:06 Monterrey (read-only source recovery)

Repository revalidation: `main` HEAD `8a44fea710e6cab0413e2049f94c9a76f7596b4e`; feature branch before this evidence update `36a9c0551250b7ed896456c4c4c43490dd6cfdbc`. The feature tree includes the 100-card CSV, the source-search journal, and the extractor. CSV has 100 data rows and 24 headers; first 50 records remain `awaiting_source_image`.

### Attempts and disposition

- Original Steam face-sheet URL: publicly indexed URL and image endpoint attempted; unavailable from web fetch, and no valid image bytes were acquired. **Not a visual identification**.
- Search by exact image UGC ID `1679241899324398994` and SHA-like path segment `5C11A2D50C1A71340C770FB2C516286AC37727DF`: no attributable copy recovered.
- Steam Workshop searches for the game and version: generic or unrelated results. No verified card art.
- Local ChatGPT file library: searched for `TS_Save_37.json`, original sheets, and Poison Legacy assets; nothing pertinent located.
- 50 individual visual comparisons and reverse-image searches: **not performed**, because the visual reference image is missing.
- Results remain exact=0; probable=0; unresolved=50. Source artist/rights/dimensions remain **unknown**. Do not promote any text-search result to a visual match.

### Concrete recovery route for a previously loaded Tabletop Simulator mod

On Windows check `%USERPROFILE%\\Documents\\My Games\\Tabletop Simulator\\Mods\\Images` for cached copies. The TTS save `TS_Save_37.json` may also help locate asset URLs. Search for the recorded face UGC identifier, or inspect images visually if filenames are hashed. Use a **copy** of a matching sheet; do not overwrite cache files.

When a real sheet is recovered, run `python tools/poison_chalice_extract_reference.py --input "path/to/sheet.jpg"` from the repository root, verify the contact sheet visually, and start source searches for cards #01–#10. Keep all candidate matches unverified until composition is compared and source credited.

### Evidence boundary

This entry establishes a reproducible image-recovery plan, **not** identified source artwork. The next continuation must prioritize acquiring the actual pixels before asserting any image/artist correspondence.
