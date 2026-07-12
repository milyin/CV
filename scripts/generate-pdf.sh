#!/bin/sh
# Generate the CV PDF locally.
#
# The PDF includes extra data that is deliberately absent from cv.yml: the
# repository and the GitHub Pages site are public, so the published page
# carries less. The data is stored here lightly scrambled (reversed, then
# base64) to keep it away from bots scraping the repository, and is injected
# into a temporary copy of cv.yml that is deleted after generation.
#
# Usage: scripts/generate-pdf.sh [theme] [output-dir]
#   theme       cvwonder theme name (default: twocolumn)
#   output-dir  output directory (default: generated/<theme>)
set -eu
cd "$(dirname "$0")/.."

THEME="${1:-twocolumn}"
OUT="${2:-generated/$THEME}"

EXTRA_DATA="$(printf '%s' 'ODAgODggMDUgNzIgNiAzMysgOmVub2hwICAK' | base64 -d | rev)"

trap 'rm -f cv-local.yml' EXIT
perl -pe "s{^(  email:.*)\$}{\$1\n$EXTRA_DATA}" cv.yml > cv-local.yml

./bin/cvwonder generate -i cv-local.yml -o "$OUT" -t "$THEME" -f pdf

# cvwonder names the output after the input file
if [ -f "$OUT/cv-local.pdf" ]; then
  mv "$OUT/cv-local.pdf" "$OUT/cv.pdf"
fi
rm -f "$OUT/cv-local.html"

echo "PDF written to $OUT/cv.pdf"
