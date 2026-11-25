#!/usr/bin/env bash
# Before upgrading DocuSeal: show which upstream files this overlay replaces or hooks into have changed.
# Usage: scripts/check-upstream.sh 3.3.8 3.4.0
set -euo pipefail
OLD=${1:?old DocuSeal tag}
NEW=${2:?new DocuSeal tag}
RAW=https://raw.githubusercontent.com/docusealco/docuseal

# Views replaced wholesale (any upstream change must be merged by hand).
REPLACED=(
  app/views/layouts/_head_tags.html.erb
  app/views/pages/landing.html.erb
  app/views/shared/_email_attribution.html.erb
  app/views/shared/_html_title.html.erb
  app/views/shared/_logo.html.erb
  app/views/shared/_meta.html.erb
  app/views/shared/_powered_by.html.erb
  app/views/shared/_title.html.erb
  app/views/start_form/_docuseal_logo.html.erb
  app/views/submit_form/_docuseal_logo.html.erb
)
# Files whose methods or constants config/initializers/daverson_branding.rb relies on.
HOOKED=(
  lib/submissions/generate_audit_trail.rb
  lib/submissions/generate_result_attachments.rb
  lib/pdf_icons.rb
)

status=0
for f in "${REPLACED[@]}" "${HOOKED[@]}"; do
  if ! new=$(curl -fsS "$RAW/$NEW/$f"); then
    echo "MISSING  $f (gone in $NEW: rework the overlay)"; status=1; continue
  fi
  old=$(curl -fsS "$RAW/$OLD/$f")
  if [ "$old" = "$new" ]; then
    echo "same     $f"
  else
    echo "CHANGED  $f"; status=1
    diff <(printf '%s\n' "$old") <(printf '%s\n' "$new") | head -40 || true
  fi
done

hooked_src=$(for f in "${HOOKED[@]}"; do curl -fsS "$RAW/$NEW/$f"; done)
for hook in 'def add_logo' 'def sign_reason' 'SIGN_REASON =' 'def logo_io' 'def stamp_logo_io'; do
  grep -qF "$hook" <<<"$hooked_src" || { echo "HOOK GONE: '$hook' not found in $NEW"; status=1; }
done

exit $status
