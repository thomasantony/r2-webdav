# R2 WebDAV for Zotero

[![Deploy to Cloudflare Workers](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/abersheeran/r2-webdav)

This Worker provides a WebDAV interface to Cloudflare R2 for Zotero. It supports WebDAV Class 1 and Class 2 (including `LOCK`/`UNLOCK`). The checked-in configuration binds it to the existing `zotero-db` bucket.

## Deploy

Prerequisites:

- The `zotero-db` R2 bucket exists in the target Cloudflare account.
- Node.js/npm are installed.
- Wrangler is authenticated to that account. Run `npx wrangler login`, or set `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` in your shell/CI environment. Never commit these values.

The API token, if you use one, needs permission to deploy Workers, manage Worker secrets, and access R2. A scoped token should include `Workers Scripts:Edit`, `Workers Secrets:Edit`, and `Workers R2 Storage:Edit`. Interactive `npx wrangler login` is also supported.

Deploy the Worker:

```bash
npx wrangler deploy
```

Set the WebDAV Basic Auth credentials interactively. Wrangler sends them to Cloudflare as encrypted Worker secrets; they are not written to this repository:

```bash
npx wrangler secret put USERNAME
npx wrangler secret put PASSWORD
```

Run `npx wrangler deploy` again if Wrangler requests it after setting the secrets. Use `https://zotero-db.thomasantony.net` in Zotero's WebDAV settings with the same username and password. The `workers.dev` URL is also available as a fallback. Do not use the R2 dashboard URL as Zotero's WebDAV endpoint.

The custom domain requires `thomasantony.net` to be an active Cloudflare zone, and `zotero-db.thomasantony.net` must not already have a conflicting CNAME record. Wrangler asks Cloudflare to create the DNS record and certificate automatically. DNS and certificate provisioning can take a short time after the first deploy.

For future setup, run [`scripts/setup-r2-webdav.sh`](scripts/setup-r2-webdav.sh). It checks the bucket, deploys the Worker, and prompts for both secrets without echoing them.

## Development

```bash
npm run dev
npm run deploy
```

Use [litmus](https://github.com/notroj/litmus) to test. GitHub Actions runs the `basic`, `copymove`, `props`, and `locks` suites against `wrangler dev --local`.
