# syntax=docker/dockerfile:1
#
# Stirling PDF 3.5.0 for Railway.
#
# The official "standard" image (login-capable build with LibreOffice, Tesseract
# OCR, OCRmyPDF and qpdf; ~1.1 GB compressed, under Railway's 4 GB image cap),
# unchanged, plus one start script that checks the deploy-form values before
# Stirling PDF reads them. Without a usable initial password Stirling PDF would
# create the well-known default login admin/stirling, so an unusable password
# locks the first admin with a random one instead (STANDARD 8.29, 8.37).
#
# Pin (checked 2026-11-24 on Docker Hub): stirlingtools/stirling-pdf:3.5.0
# index digest, pushed 2026-11-22. The ultra-lite variant has no login; the fat
# variant only adds extra fonts and the optional AI engine.
ARG STIRLING_IMAGE=stirlingtools/stirling-pdf:3.5.0@sha256:f5a38801f2dd551c26d0089ee3ea48d86a565e3adb414cb31e974bc9562cb48a
FROM ${STIRLING_IMAGE}

COPY --chmod=0755 railway-start.sh /usr/local/bin/railway-start

EXPOSE 8080
# The image's own entrypoint is tini -> /scripts/init.sh; keep tini as the reaper.
ENTRYPOINT ["tini", "--", "/usr/local/bin/railway-start"]
CMD []
