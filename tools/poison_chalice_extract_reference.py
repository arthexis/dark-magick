#!/usr/bin/env python3
"""Extract 50 visual reference cards from Poison Legacy's original 10x7 TTS sheet.

Usage:
  python tools/poison_chalice_extract_reference.py --input "/path/to/original-sheet.jpg"
  python tools/poison_chalice_extract_reference.py --input-url
Requires Pillow; urllib is used only when --input-url is explicitly supplied.
Output is intended for visual source identification, not clean artwork.
"""
import argparse
import hashlib
import io
import json
from pathlib import Path
from urllib.request import Request, urlopen

from PIL import Image, ImageDraw, ImageFont

FACE_URL = (
    "https://cloud-3.steamusercontent.com/ugc/1679241899324398994/"
    "5C11A2D50C1A71340C770FB2C516286AC37727DF/"
)
NUM_COLUMNS = 10
NUM_ROWS = 7
CARD_COUNT = 50


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    inp = ap.add_mutually_exclusive_group(required=True)
    inp.add_argument("--input", type=Path, help="Local original face sheet")
    inp.add_argument("--input-url", action="store_true", help="Fetch recorded Steam sheet")
    ap.add_argument("--output", type=Path, default=Path("build/poison-chalice-visual-reference"))
    args = ap.parse_args()

    if args.input_url:
        request = Request(FACE_URL, headers={"User-Agent": "PoisonChaliceReference/1.0"})
        try:
            with urlopen(request, timeout=30) as response:
                raw = response.read(32 * 1024 * 1024 + 1)
        except Exception as exc:
            ap.error(f"Cannot retrieve Steam sheet ({exc}). Supply --input path instead.")
        if len(raw) > 32 * 1024 * 1024:
            ap.error("Image exceeds 32 MiB limit")
        reference = FACE_URL
    else:
        if not args.input.is_file():
            ap.error(f"Missing sheet: {args.input}")
        raw = args.input.read_bytes()
        reference = str(args.input)

    try:
        source = Image.open(io.BytesIO(raw))
        source.load()
        source = source.convert("RGB")
    except Exception as exc:
        ap.error(f"Not a readable image: {exc}")
    width, height = source.size
    if width < 1000 or height < 700:
        ap.error(f"Sheet unexpectedly small ({width}x{height}); check original input")

    args.output.mkdir(parents=True, exist_ok=True)
    records = []
    thumbs = []
    for card_id in range(1, CARD_COUNT + 1):
        col, row = (card_id - 1) % NUM_COLUMNS, (card_id - 1) // NUM_COLUMNS
        left = round(col * width / NUM_COLUMNS)
        top = round(row * height / NUM_ROWS)
        right = round((col + 1) * width / NUM_COLUMNS)
        bottom = round((row + 1) * height / NUM_ROWS)
        card = source.crop((left, top, right, bottom))
        filename = f"card-{card_id:02d}.png"
        card.save(args.output / filename)
        thumb = card.copy()
        thumb.thumbnail((220, 308), Image.Resampling.LANCZOS)
        thumbs.append((card_id, thumb))
        records.append({
            "card_number": card_id,
            "sprite_row": row + 1,
            "sprite_column": col + 1,
            "crop_box": [left, top, right, bottom],
            "image": filename,
            "source": reference,
            "status": "reference_extracted_not_art_attributed"
        })

    cell_w, cell_h, margin, label_h = 240, 340, 12, 26
    overview = Image.new("RGB", (5 * cell_w, 10 * cell_h), "#f4f4f4")
    painter = ImageDraw.Draw(overview)
    for k, (card_id, thumb) in enumerate(thumbs):
        x, y = (k % 5) * cell_w, (k // 5) * cell_h
        painter.text((x + margin, y + 3), f"#{card_id:02d}", fill="#151515")
        overview.paste(thumb, (x + margin, y + label_h))
    overview.save(args.output / "contact-sheet-50.jpg", quality=92)

    manifest = {
        "expansion": "poison-legacy",
        "sheet_sha256": hashlib.sha256(raw).hexdigest(),
        "sheet_size": [width, height],
        "layout": [NUM_COLUMNS, NUM_ROWS],
        "reference_only": True,
        "cards": records,
    }
    (args.output / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"Extracted {len(records)} card references into {args.output}")


if __name__ == "__main__":
    main()
