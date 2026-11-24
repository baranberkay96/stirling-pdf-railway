# Deploy and Host Stirling PDF with Railway

Stirling PDF is a self-hosted PDF toolkit with more than 50 tools: merge, split, compress, OCR, convert to and from Office and images, sign, redact, watermark and more, in a web interface or through a REST API. This template runs Stirling PDF 3.5 with login switched on and a generated admin password.

> Community template, not affiliated with Stirling PDF Inc.

## About Hosting Stirling PDF

Stirling PDF is a Java (Spring Boot) application with a React interface, bundled with LibreOffice, Tesseract/OCRmyPDF, qpdf and Ghostscript for the heavy lifting. Files are processed on your server and are not stored after processing, which makes it a private alternative to online PDF sites.

This template uses the official login-capable image and pre-creates the first admin from generated variables, so the site never shows the upstream default `admin`/`stirling` login. Settings, the user database and logs live on a Railway volume at `/configs`, so accounts and configuration survive redeploys. A global API key is generated too, for scripts and automations.

## Common Use Cases

- A private PDF workspace for a team: merge, split, compress, rotate and reorder without uploading documents to third-party sites
- OCR scanned documents into searchable PDFs
- Convert Word, Excel, PowerPoint, HTML and images to PDF and PDFs back to images or Office formats
- Redact, watermark, sign and add passwords before sharing documents
- Automate PDF steps from n8n, Make or your backend through the REST API

## Dependencies for Stirling PDF Hosting

- Stirling PDF service (repo build on `stirlingtools/stirling-pdf:3.5.0`, pinned by digest)
- Railway volume at `/configs`

### Deployment Dependencies

- [Stirling PDF documentation](https://docs.stirlingpdf.com)
- [Stirling PDF on GitHub](https://github.com/Stirling-Tools/Stirling-PDF)
- [Plans and licences](https://docs.stirlingpdf.com/Server/Licensing/Plans-and-Licences/)
- [Template source](https://github.com/baranberkay96/stirling-pdf-railway)

### Implementation Details

| Service | Purpose |
|---|---|
| Stirling PDF | Web interface and REST API on port 8080, public HTTPS domain, volume at `/configs` |

**First login**

1. Open the Stirling PDF service, Variables tab, and copy `SECURITY_INITIALLOGIN_USERNAME` (default `admin`) and `SECURITY_INITIALLOGIN_PASSWORD`.
2. Open the public domain and sign in. The first start takes one to two minutes (Java and LibreOffice warm up).
3. Change the password under Account settings and add users for your team in the admin settings.

The initial credentials are used only when the user database is empty (first boot). Later changes to these variables do not change existing passwords.

**API**

Call any tool with the generated key: `curl -H "X-API-KEY: {SECURITY_CUSTOMGLOBALAPIKEY}" -F fileInput=@in.pdf https://{your-domain}/api/v1/misc/compress-pdf -o out.pdf`. The API reference is at `https://{your-domain}/swagger-ui/index.html`.

**Security defaults**

- Login is always on while the service has a public domain (`SECURITY_ENABLELOGIN=false` is ignored then).
- An initial password that is empty, shorter than 12 or longer than 128 characters, or contains spaces never falls back to the upstream default: the first admin gets a random password and the log explains how to fix it.
- An API key shorter than 24 characters is switched off instead of being accepted.

**Licence note**

Stirling PDF is open-core. The PDF tools are MIT-licensed; login, user management and other server features are in the proprietary module under the Stirling PDF User License. According to the Stirling PDF plans page, the Free plan allows 5 users and includes all PDF tools; more users and features such as external databases, audit logs or SAML need a paid Team or Enterprise licence from Stirling PDF Inc. Check the licence terms for your use; this template does not include a licence.

**Resources**

Measured on Railway: about 0.6 GB RAM idle after start-up, with short CPU bursts while a tool runs; OCR and Office conversions of large files temporarily need more memory. A Trial plan (1 GB) works for light use; Hobby is recommended for OCR of large scans and several users. The JVM heap is sized from the service memory limit automatically.

**Upgrading**: the image is pinned by digest in `services/stirling-pdf/Dockerfile` of the template repository. Change tag and digest to a newer release and redeploy; the database migrates on start. Read the release notes before major upgrades.

### Why Deploy Stirling PDF on Railway?

Railway runs Stirling PDF with HTTPS, a persistent volume and generated credentials in a few minutes. Your documents are processed on your own service instead of a public PDF website, and you pay for the memory and CPU the tools actually use.
