#!/usr/bin/env python3
"""Record an evidence-backed Poison Legacy source-sheet recovery in the tracker."""

import csv
from pathlib import Path


TRACKER = Path("tomes/poison-chalice/poison-chalice-card-tracker.csv")
SHA256 = "1a6070c3aadcc219b387fe46f8423f65b1282d00c6bccfbfc1740807c14c02c1"
NOTE = (
    "Source sheet recovered locally on 2026-11-12; SHA-256 "
    f"{SHA256}. Full-card reference extracted; no source artwork attribution yet."
)


def main() -> None:
    with TRACKER.open(newline="", encoding="utf-8-sig") as source:
        reader = csv.DictReader(source)
        fieldnames = reader.fieldnames
        rows = list(reader)

    updated = 0
    for row in rows:
        if row["origin"] != "poison-legacy":
            continue
        row["art_status"] = "source_sheet_recovered"
        row["visual_search_status"] = "reference_ready_not_searched"
        if NOTE not in row["notes"]:
            row["notes"] = f"{row['notes'].rstrip()} {NOTE}".strip()
        updated += 1

    with TRACKER.open("w", newline="", encoding="utf-8") as destination:
        writer = csv.DictWriter(destination, fieldnames=fieldnames, quoting=csv.QUOTE_ALL)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Recorded source-sheet recovery for {updated} Poison Legacy cards.")


if __name__ == "__main__":
    main()
