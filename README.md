# Voice Memos

Private voice diary for thoughts, todos, and reflections. It records in the
browser, transcribes through a Cloudflare Worker, stores only transcripts, and
turns entries into a searchable diary with categories and evening digests.

## What It Does

- Password + authenticator login
- Records audio in the browser
- Sends audio to Cloudflare Worker
- Transcribes with Workers AI `@cf/openai/whisper`
- Discards audio immediately
- Stores only transcript metadata in D1
- Organizes older entries into a Diary tab grouped by year, month, and day
- Supports transcript and category editing
- Searches diary entries by text, category, and date range
- Sends an evening report by email
- Supports manual text memos and "send report now"
- Lets you compare Llama, Qwen, and Kimi for manual reports

## Screenshots

Today view for capture, manual notes, and report actions:

![Today view](helpers/Screenshot%202026-06-01%20222956.png)

Diary view with search, category, and date filters:

![Diary view](helpers/Screenshot%202026-06-01%20223305.png)

Password and authenticator login:

![Login view](helpers/Screenshot%202026-06-01%20223326.png)

## Security Model

This is designed for a single owner, not public signups.

- Password + TOTP login protects the UI and API.
- Session cookies are signed, HttpOnly, Secure, and SameSite=Lax.
- Audio is never stored. It is passed to Workers AI for transcription and then discarded.
- Transcripts are stored in D1.
- Secrets are set with `wrangler secret put`, not committed.

Anyone who forks this repo must create their own Cloudflare D1 database, Workers AI binding, Resend API key, password hash, TOTP secret, and session secret. The public code does not grant access to your deployment.

## Setup

Install Wrangler dependencies:

```bash
npm install
```

Create the D1 database:

```bash
npm run db:create
```

Copy the returned `database_id` into `wrangler.toml`.

Apply migrations:

```bash
npm run db:migrate:remote
```

Generate a password hash:

```bash
node scripts/hash-password.mjs 'choose a long password'
```

Generate an authenticator secret:

```bash
node scripts/totp-secret.mjs 'Voice Memos' 'owner'
```

Add the URI to your authenticator app, then set secrets:

```bash
wrangler secret put VOICE_PASSWORD_HASH
wrangler secret put VOICE_TOTP_SECRET
wrangler secret put VOICE_SESSION_SECRET
wrangler secret put RESEND_API_KEY
```

`VOICE_SESSION_SECRET` should be a long random string.

Update `OWNER_EMAIL`, `OWNER_TIMEZONE`, `REPORT_HOUR_LOCAL`, `SUMMARY_MODEL`, and `RESEND_FROM_EMAIL` in `wrangler.toml` or in your deployed Cloudflare Worker settings.

The committed defaults are intentionally generic:

```toml
OWNER_EMAIL = "you@example.com"
RESEND_FROM_EMAIL = "Voice Memos <memos@example.com>"
SUMMARY_MODEL = "@cf/qwen/qwen3-30b-a3b-fp8"
```

Deploy:

```bash
npm run deploy
```

## Notes

The app does not save audio. The audio blob is sent to the Worker, passed to Whisper, and then discarded. Only the transcript, category, timestamp, and optional duration are stored.

The scheduled report cron runs every 30 minutes and sends only when the local hour matches `REPORT_HOUR_LOCAL`. It skips if a report has already been sent for that local date unless you click "Send today's report now."

## Local Overrides

Use `.dev.vars` for local-only values:

```bash
cp .dev.vars.example .dev.vars
```

`.dev.vars` is ignored by git.

## Cost Notes

For personal use, the main costs are usually tiny:

- Whisper transcription through Workers AI
- one daily summary model call
- Resend email
- Cloudflare Worker/D1 usage

The default summary model is Qwen:

```toml
SUMMARY_MODEL = "@cf/qwen/qwen3-30b-a3b-fp8"
```

Manual reports can still be sent with Llama, Qwen, or Kimi from the UI.

## Copyright and License

Copyright (c) 2026 Nitish R. Sinha.

This repository is currently released under the MIT License, which is permissive:
others may use, copy, modify, publish, distribute, sublicense, and sell copies of
the software as long as they preserve the copyright and license notice.

If you want stronger control over reuse, replace the MIT License with a
source-available or proprietary license before treating the repository as a
public project. Copyright can protect the source code and written materials, but
it does not protect the underlying idea, workflow, or product concept.
