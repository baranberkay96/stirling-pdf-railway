# Stirling PDF 3 Self-Hosted PDF Toolkit: Railway template spec

## Listing

| Field | Value |
|---|---|
| Name | **Stirling PDF 3 Self-Hosted PDF Toolkit** |
| Description | 50+ PDF tools in your browser: merge, split, OCR, convert, sign. Login on. (74 chars) |
| Category | Other |
| Icon | `https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/stirling-pdf.svg` |
| Repo | `baranberkay96/stirling-pdf-railway`, root `/services/stirling-pdf` |

## Base market templates

| Code | Active | Notes |
|---|---|---|
| `Rn4VSj` | 42 | `frooodle/s-pdf:latest` (old repo name), security off, volume on tessdata only, no healthcheck |
| `stirling` | 20 | same image, security off, broken mount path |
| `ZelMkZ` | 5 | `latest-fat`, login on, empty initial login (default admin/stirling), `-Xmx3g` |

### Improvements over market templates

- Pinned 3.5.0 by digest (current release, 2026-11-22) instead of `latest`.
- Login on with a pre-created admin from generated variables (no default admin/stirling, setup marked complete; STANDARD 8.37); login forced on while a public domain exists.
- Volume on `/configs` (settings, user DB, AOT cache, logs config) so users and settings persist.
- Healthcheck `/api/v1/info/status`, `ALWAYS` restart, generous timeout for first JVM start.
- Generated global API key; forward-header strategy for correct https links behind Railway.
- Start script: invalid values fall back or fail closed (8.29).

### Image variant (STANDARD 8.33 / 8.31)

| Variant | Compressed (amd64) | Login | Choice |
|---|---|---|---|
| `3.5.0` (standard) | 1.12 GB | yes | **used** |
| `3.5.0-fat` | 1.17 GB | yes | extra fonts + optional AI engine; not needed |
| `3.5.0-ultra-lite` | 0.36 GB | no | no login, cannot be exposed safely |

All are under the 4 GB build cap. RAM measured in the deploy test (see report).

## Services

| Service | Source | Healthcheck | Domain | Volume |
|---|---|---|---|---|
| Stirling PDF | repo `/services/stirling-pdf` (FROM official image + start script) | `/api/v1/info/status`, 900 s | public, 8080 | `/configs` |

## Resource profile

Measured 2026-11-24: idle 0.93 GB with the Hobby limit (~$9/month), 0.5-1.0 GB under a 1 GB Trial limit (all tested tools worked). Minimum plan: Trial for light use; Hobby recommended.

## Verification checklist

1. Deploy SUCCESS; `/api/v1/info/status` 200 `UP`.
2. Login page; generated admin logs in; wrong password rejected; default admin/stirling rejected.
3. Merge two PDFs and compress one via the API with the global key; a tool in the UI.
4. Redeploy: users persist.
5. Password `abc`: deploy succeeds, login locked, log explains.

## Open questions

- Licence: Free plan limited to 5 users (proprietary module). Documented in README/NOTICE; user decision whether that is acceptable for the marketplace.
