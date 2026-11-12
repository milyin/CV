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
- `themes/letter/` — custom cover-letter theme (classic full-block business letter)
- `letters/` — cover letters: `TEMPLATE.yml` (copy this to start a new one) and one YAML file per application
- `generated/` — build output (`cv.html`, `cv.pdf`, `letters/*.pdf`)
- `bin/cvwonder` — the CV Wonder binary (v0.10.1, darwin/arm64)
- `scripts/generate-pdf.sh` — local PDF generation (injects the extra data)
- `scripts/generate-cover-letter-pdf.sh` — cover letter PDF generation

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

## Cover letters

Cover letters live in `letters/` and are rendered with the `letter` theme as a
classic full-block business letter: letterhead, date, inside address, subject
line, salutation, body, complimentary close, signature space, typed name and
enclosures — everything flush left, no paragraph indentation, one page.

Start from [letters/TEMPLATE.yml](letters/TEMPLATE.yml):

```sh
cp letters/TEMPLATE.yml letters/acme-staff-engineer.yml
$EDITOR letters/acme-staff-engineer.yml
./scripts/generate-cover-letter-pdf.sh letters/acme-staff-engineer.yml
# -> generated/letters/acme-staff-engineer.pdf
```

CV Wonder's schema is fixed and has no letter fields, so the theme carries them
in CV fields:

| Letter element | YAML field |
| --- | --- |
| Letterhead (sender) | `person.*`, `socialNetworks.*` |
| Date | `career[0].missions[0].dates` |
| Recipient name / title | `career[0].missions[0].position` |
| Recipient department | `career[0].missions[0].company` |
| Recipient organisation | `career[0].companyName` |
| Recipient address | `career[0].missions[0].location` (one line per line of a `\|` block) |
| Subject line | `career[0].missions[0].summary` |
| Salutation, complimentary close | `career[0].missions[0].description`, as `Salutation: …` / `Closing: …` lines |
| Enclosures | `career[0].missions[0].technologies` |
| Body paragraphs | `abstract` |

Notes:

- `dates: today` is replaced by the generation script with the date of
  rendering, so a letter kept on file always prints with a current date.
- Without the `Salutation:` / `Closing:` lines the salutation is derived from
  the recipient (`Dear Hiring Team,`; a `Name, Title` recipient keeps only the
  name) and the close is `Sincerely,`.
- Body paragraphs are emitted verbatim, so inline HTML works — in particular
  `<a href="…">…</a>` for the links that a plain-text letter cannot carry. Each
  body link is coloured, marked with a superscript number, and listed by that
  number at the foot of the letter, so a printed copy keeps the references.
  Write the href with double quotes — that is how the theme finds the targets.
  Letterhead links are not numbered: they already show their URL as link text.
- Everything but `person.name` and `abstract` is optional; missing parts are
  simply left out.
- `person.depiction` is drawn above the typed name as a scanned signature. Like
  the CV photo it must be reachable from the theme directory (cvwonder copies
  only theme files into the output).

## Usage

```sh
# Generate HTML (this is what CI publishes)
./bin/cvwonder generate -i cv.yml -o generated/twocolumn -t twocolumn

# Generate PDF (local only, not published)
./scripts/generate-pdf.sh            # default theme: twocolumn
./scripts/generate-pdf.sh compact    # any other theme

# Cover letter PDF
./scripts/generate-cover-letter-pdf.sh letters/black-forest-cover-letter.yml

# Live preview with hot reload at http://localhost:3000
./bin/cvwonder serve -i cv.yml -t twocolumn
./bin/cvwonder serve -i letters/black-forest-cover-letter.yml -t letter  # date shows as "today"
```

Note: `./bin/cvwonder validate -i cv.yml` reports "level is required" for every
technical-skill competency — the levels are omitted intentionally (no theme in
use renders them), and `generate` handles their absence fine.
