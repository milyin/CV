#!/bin/sh
# Generate a cover letter PDF from a letter YAML file.
#
# The letter is rendered with the `letter` theme (classic full-block business
# letter); see letters/TEMPLATE.yml for the field mapping.  A `dates: today`
# entry is replaced with the date of rendering, so a letter kept on file always
# prints with the current date.
#
# Usage: scripts/generate-cover-letter-pdf.sh <letter-file> [theme] [output-dir]
#   letter-file  path to the cover letter YAML file
#   theme        cvwonder theme name (default: letter)
#   output-dir   output directory (default: generated/letters)
set -eu
cd "$(dirname "$0")/.."

if [ $# -lt 1 ]; then
  echo "Usage: $0 <letter-file> [theme] [output-dir]" >&2
  exit 1
fi

LETTER="$1"
THEME="${2:-letter}"
OUT="${3:-generated/letters}"

if [ ! -f "$LETTER" ]; then
  echo "Error: File not found: $LETTER" >&2
  exit 1
fi

NAME=$(basename "$LETTER" | sed 's/\.[^.]*$//')
mkdir -p "$OUT"

# cvwonder names its output after the input file, so render from a temporary
# copy that carries the resolved date and delete it afterwards.
TMP="$OUT/$NAME-rendering.yml"
trap 'rm -f "$TMP" "$OUT/$NAME-rendering.html"' EXIT

TODAY=$(date "+%-d %B %Y")
sed "s/^\( *dates: *\)today *\$/\1$TODAY/" "$LETTER" > "$TMP"

./bin/cvwonder generate -i "$TMP" -o "$OUT" -t "$THEME" -f pdf >/dev/null

mv "$OUT/$NAME-rendering.pdf" "$OUT/$NAME.pdf"
echo "PDF written to $OUT/$NAME.pdf"
