# CV — Mikhail ILIN

CV project powered by [CV Wonder](https://github.com/germainlefebvre4/cvwonder).

Published via GitHub Pages on every push to `main` (see `.github/workflows/publish.yml`):

- HTML: <https://milyin.github.io/CV/>

The PDF is generated locally with `scripts/generate-pdf.sh` and is not published. It includes extra data that is kept out of `cv.yml`; the script stores it scrambled and injects it into a temporary copy of `cv.yml` during generation.

## Layout

- [cv.yml](cv.yml) — the CV content (edit this file)
- `images/profile.jpg` — the CV photo (square, 400×400). Replace this file to change the photo; `themes/twocolumn/images/profile.jpg` is a symlink to it (cvwonder only copies theme files into the output, so the photo must be reachable through the theme directory)
- `themes/default/`, `themes/basic/`, `themes/horizon-timeline/` — the three official CV Wonder themes
- `themes/compact/` — custom dense theme (2-page output), derived from the default theme
- `themes/twocolumn/` — custom two-column theme (orange accents, sidebar with contact/skills/education, no photo)
- `generated/` — build output (`cv.html`, `cv.pdf`)
- `bin/cvwonder` — the CV Wonder binary (v0.10.1, darwin/arm64)
- `scripts/generate-pdf.sh` — local PDF generation (injects the extra data)

## Data conventions

All CV content lives in `cv.yml`; the themes contain no personal data. CV Wonder's
schema is fixed, so a few fields carry structured content the `twocolumn` theme
interprets:

- `person.name` — a parenthesized alternative spelling (`Mikhail ILIN (Michael Ilyin)`)
  is rendered as a styled secondary name; the part before the parenthesis is used
  for the page title and photo alt text.
- `sideProjects[].description` — may be multi-line: the first line is the
  description, each following `Label: URL` line is rendered as an extra link line
  under the project link. Other themes render the block as plain text, which stays readable.
- `certifications[].companyName` — acts as a grouping label: consecutive entries
  sharing a `companyName` form one sidebar section with that heading (e.g. `Patents`).

## Usage

```sh
# Generate HTML (this is what CI publishes)
./bin/cvwonder generate -i cv.yml -o generated/twocolumn -t twocolumn

# Generate PDF (local only, not published)
./scripts/generate-pdf.sh            # default theme: twocolumn
./scripts/generate-pdf.sh compact    # any other theme

# Live preview with hot reload at http://localhost:3000
./bin/cvwonder serve -i cv.yml -t twocolumn
```

Note: `./bin/cvwonder validate -i cv.yml` reports "level is required" for every
technical-skill competency — the levels are omitted intentionally (no theme in
use renders them), and `generate` handles their absence fine.
