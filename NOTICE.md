# NOTICE: Stirling PDF 3 Self-Hosted PDF Toolkit template

This is a community template. It is not affiliated with or endorsed by Stirling PDF Inc. or Railway. Stirling PDF is a trademark of Stirling PDF Inc.

## Components

| Component | Source | License | How it is used |
|---|---|---|---|
| Stirling PDF 3.5.0 | https://github.com/Stirling-Tools/Stirling-PDF, image `stirlingtools/stirling-pdf:3.5.0@sha256:f5a38801f2dd551c26d0089ee3ea48d86a565e3adb414cb31e974bc9562cb48a` | Open-core: MIT for most of the code; `app/proprietary/` (login, user management, server features) under the Stirling PDF User License; other listed folders under their own licences (see the repository's LICENSE) | Base image, unmodified, pulled from Docker Hub at build time |
| LibreOffice, Tesseract, OCRmyPDF, qpdf, Ghostscript and other packages inside the image | bundled by the Stirling PDF image | each package's own licence (MPL-2.0, Apache-2.0, MPL-2.0, Apache-2.0, AGPL-3.0, ...) | Run by Stirling PDF inside the container |
| Stirling PDF icon | https://github.com/homarr-labs/dashboard-icons (`svg/stirling-pdf.svg`) | Apache-2.0 (collection); logo belongs to Stirling PDF Inc. | Marketplace icon |

**User licence caveat.** Login and user management come from the proprietary module. The upstream plans page (checked 2026-11-24) states that the Free plan allows 5 users and includes all PDF tools; larger teams and Team/Enterprise features need a paid licence from Stirling PDF Inc. Each deployer is responsible for complying with the Stirling PDF licence for their use. This template does not distribute Stirling PDF; Railway builds it from the official image.

## Files written for this template

`services/stirling-pdf/Dockerfile` and `services/stirling-pdf/railway-start.sh` were written for this template (no upstream file copied) and are offered under the MIT License. The start script validates the template variables and execs the image's unchanged `/scripts/init.sh`.

## Upstream checked (2026-11-24, tag v3.5.0)

- `docker/embedded/Dockerfile` (variants, tini entrypoint, `/configs` volume, port 8080, healthcheck `/api/v1/info/status`), `scripts/init.sh` and `scripts/init-without-ocr.sh` (memory sizing from the cgroup limit, AOT cache, optional AI engine off unless enabled).
- `app/core/src/main/resources/settings.yml.template` (security.enableLogin, security.initialLogin, customGlobalAPIKey, system.maxFileSize).
- `app/proprietary/.../InitialSecuritySetup.java`: with an empty initial login the first boot creates `admin`/`stirling`; with initialLogin set it creates that admin without the first-login prompt and marks setup complete.
- `LICENSE`, `app/proprietary/LICENSE`, docs pages "Plans and Licences" and "Sign in and Security".

## Market templates reviewed

`Rn4VSj` "Stirling-PDF" (42 active) and `stirling` "Stirling PDF" (20 active) both deploy `frooodle/s-pdf:latest` with security disabled (an open PDF service on a public domain) and no healthcheck; `ZelMkZ` (5 active) uses `latest-fat` with login on but empty initial credentials (falls back to admin/stirling). Nothing was copied.
