# DocuSeal for Daverson Hall

This is the document-signing service at <https://sign.daversonhall.co.uk>. It is the open-source [DocuSeal](https://github.com/docusealco/docuseal) with Daverson Hall's name and logo instead of DocuSeal's. It's built as a thin layer on the official Docker image, so it stays easy to upgrade.

## What's changed

| What people see | Change | File |
|---|---|---|
| Signing page header | Hall logo and "Daverson Hall", linking to the hall website | `overrides/app/views/submit_form/_docuseal_logo.html.erb` |
| Public template link header | Same | `overrides/app/views/start_form/_docuseal_logo.html.erb` |
| Logo everywhere else | Hall mark instead of the DocuSeal logo | `overrides/app/views/shared/_logo.html.erb`, `_title.html.erb` |
| Home page for visitors | A short Daverson Hall page instead of DocuSeal's product page | `overrides/app/views/pages/landing.html.erb` |
| Browser tab and link previews | "… \| Daverson Hall", hall description and preview image | `overrides/app/views/layouts/_head_tags.html.erb`, `shared/_html_title.html.erb`, `shared/_meta.html.erb`, `overrides/public/` |
| Email footer | "Sent by Daverson Hall", with a small DocuSeal credit | `overrides/app/views/shared/_email_attribution.html.erb` |
| Audit-log PDF | Hall logo and name in the header | `overrides/config/initializers/daverson_branding.rb`, `overrides/lib/pdf_icons/logo.png` |
| PDF signature reason | "Signed via sign.daversonhall.co.uk" | `overrides/config/initializers/daverson_branding.rb` |
| Stamp fields | "Daverson Hall" watermark | `overrides/lib/pdf_icons/stamp-logo.png` |
| Page footer | DocuSeal's attribution kept as it is, plus a link to this source | `overrides/app/views/shared/_powered_by.html.erb` |

## What's deliberately not changed

- **The "Powered by DocuSeal" footer.** DocuSeal's licence requires interactive screens to keep its attribution ([LICENSE_ADDITIONAL_TERMS](LICENSE_ADDITIONAL_TERMS)).
- **The "Electronic Signature Disclosure" link under the Sign button, and the credit on the "signed" screen.** These live in DocuSeal's compiled JavaScript, and changing them would mean rebuilding its front end on every upgrade.
- **Staff screens** (templates, settings) still say DocuSeal in places. Only staff see them.

## Licence

DocuSeal is licensed under the [GNU AGPL v3](LICENSE) with an [additional attribution term](LICENSE_ADDITIONAL_TERMS), and so are the changes in this repository. This repository, together with the upstream source at the tag named in the `Dockerfile`, is the complete source of the version running at sign.daversonhall.co.uk.

## Build and run

```sh
docker build -t docuseal-daverson:3.3.8-dh1 --build-arg DOCUSEAL_VERSION=3.3.8 .
```

Run the image exactly as the official one (same environment variables, same `/data/docuseal` volume).

## Upgrading DocuSeal

1. Run `scripts/check-upstream.sh <current> <new>`. It lists which replaced views changed upstream and whether the PDF hooks still exist. Merge any upstream changes into the files in `overrides/`.
2. Change `DOCUSEAL_VERSION` in the `Dockerfile`, build with a new tag (`<version>-dh1`), and test it on a copy of the data before switching the live service.

## Changing the logo

The logo is `brand/mark.svg`, a placeholder "DH" mark in the website's purple. Replace it, paste the same SVG into `overrides/app/views/shared/_logo.html.erb`, then run `scripts/make-icons.sh` (needs ImageMagick 7) to regenerate the icons and PDF images.
