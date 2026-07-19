#!/usr/bin/env bash
set -euo pipefail

bucket_name="zotero-db"

if ! command -v npx >/dev/null 2>&1; then
	printf '%s\n' 'npx is required. Install Node.js/npm first.' >&2
	exit 1
fi

printf 'Checking access to R2 bucket %s...\n' "$bucket_name"
bucket_list="$(npx wrangler r2 bucket list)"
if ! printf '%s\n' "$bucket_list" | grep -Fq "$bucket_name"; then
	printf 'Bucket %s was not found in the authenticated Cloudflare account.\n' "$bucket_name" >&2
	exit 1
fi

printf '%s\n' 'Deploying the Worker...'
npx wrangler deploy

printf '%s\n' 'Set the WebDAV username (Wrangler hides the input):'
npx wrangler secret put USERNAME

printf '%s\n' 'Set the WebDAV password (Wrangler hides the input):'
npx wrangler secret put PASSWORD

printf '%s\n' 'Secrets saved. If needed, run: npx wrangler deploy'
