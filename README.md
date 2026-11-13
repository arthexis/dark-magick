# Dark Magick

Tabletop Simulator Lua tooling and expansion definitions for **Dark Magick**.

## Included expansion

`poison-legacy` is the current 50-card deck, preserved from the original Dark
Magic Workshop mod. Its descriptor retains the original Steam-hosted face and
back images, a 10×7 card sheet layout, and the first 50 card slots.

## Tabletop Simulator use

Paste [`tts/Global.lua`](tts/Global.lua) into the Global script of a Tabletop
Simulator save. It registers Poison Legacy automatically and supports these
chat commands:

```
!darkmagick decks
!darkmagick deck poison-legacy
!darkmagick load poison-legacy,another-expansion
```

`deck` spawns one shuffled deck at the calling player's pointer. `load` sets
the active expansion list and spawns every selected deck with a small offset.
Future expansions are added by registering another descriptor with the same
fields as [`expansions/poison-legacy.lua`](expansions/poison-legacy.lua).

## Repository layout

- `tts/Global.lua` — self-contained Global script for multi-deck play.
- `tts/legacy/` — recovered and cleaned-up Fate Deck and Challenge Bag object
  scripts from the original Tabletop Simulator save.
- `expansions/poison-legacy.lua` — editable Poison Legacy deck descriptor.
- `tomes/poison-legacy/` — extracted rules, analysis, and editable 50-card
  CSV data recovered from the original Tabletop Simulator installation.

The game uses the spelling **Dark Magick** in this repository; the imported
source material may retain the original **Dark Magic** spelling.
