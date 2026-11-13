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
