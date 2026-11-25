#!/usr/bin/env bash
# Regenerate every icon and logo image in overrides/ from brand/mark.svg.
# Needs ImageMagick 7 (`magick`). Run from the repo root after changing the mark.
set -euo pipefail
cd "$(dirname "$0")/.."

MARK=brand/mark.svg
PUB=overrides/public
PDF=overrides/lib/pdf_icons
FONT="${FONT:-Arial-Bold}"
mkdir -p "$PUB" "$PDF"

# 8-bit RGBA output: the PDF library (HexaPDF) draws 16-bit PNGs washed out.
render() { # size output
  magick -background none -density 600 "$MARK" -resize "$1x$1" -depth 8 "PNG32:$2"
}

cp "$MARK" "$PUB/favicon.svg"
cp "$MARK" "$PUB/logo.svg"
for s in 16 32 96; do render "$s" "$PUB/favicon-${s}x${s}.png"; done
render 180 "$PUB/apple-icon-180x180.png"
cp "$PUB/apple-icon-180x180.png" "$PUB/apple-touch-icon.png"
cp "$PUB/apple-icon-180x180.png" "$PUB/apple-touch-icon-precomposed.png"
magick -background none -density 600 "$MARK" -define icon:auto-resize=48,32,16 "$PUB/favicon.ico"

# Link-preview image (800x800), shown when a signing link is shared in chat apps.
magick -size 800x800 xc:'#FBFAF3' \
  \( -background none -density 600 "$MARK" -resize 360x360 \) -gravity center -geometry +0-70 -composite \
  -density 72 -font "$FONT" -pointsize 76 -fill '#111111' -gravity center -annotate +0+220 'Daverson Hall' \
  -depth 8 "PNG24:$PUB/preview.png"

# PDF images: the audit-log header logo (300x300) and the stamp field's diagonal watermark (506x340).
render 300 "$PDF/logo.png"
magick -size 506x340 xc:none -font "$FONT" -pointsize 74 -fill '#707070' -gravity center \
  -annotate -33x-33+0+0 'Daverson Hall' -depth 8 "PNG32:$PDF/stamp-logo.png"

echo "Icons written to $PUB and $PDF"
