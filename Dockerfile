# DocuSeal with Daverson Hall branding (https://sign.daversonhall.co.uk).
# The official image plus a few replaced views, icons and one initializer. See README.md.
ARG DOCUSEAL_VERSION=3.3.8
FROM docuseal/docuseal:${DOCUSEAL_VERSION}

LABEL org.opencontainers.image.source="https://github.com/antmcmullen/docuseal-daverson" \
      org.opencontainers.image.description="DocuSeal with Daverson Hall branding" \
      org.opencontainers.image.licenses="AGPL-3.0-only"

COPY --chown=docuseal:docuseal overrides/app/ /app/app/
COPY --chown=docuseal:docuseal overrides/config/ /app/config/
COPY --chown=docuseal:docuseal overrides/lib/ /app/lib/
COPY --chown=docuseal:docuseal overrides/public/ /app/public/
