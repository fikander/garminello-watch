# garminello-watch

Garmin Connect IQ (Monkey C) watch app for **Garminello**. Lets a Garmin
watch browse the user's Trello boards/lists as menus and "play" a Trello
list as a timed sequence (e.g. a workout, with per-card durations parsed
from card titles like `Warm up [3m 30s]`).

Backend/companion repo: `garminello-web` (see its `CLAUDE.md` and
`docs/ARCHITECTURE.md` for the server-side API contract this app talks to).
Published on the Garmin Connect IQ Store; device support is currently
restricted to `vivoactive_hr` (see `manifest.xml`).

For deeper notes see `docs/ARCHITECTURE.md`.

## Stack

- Monkey C (Garmin Connect IQ SDK) — see the SDK links in `README.md`
- Single supported device profile: `vivoactive_hr`
- No build tooling in-repo beyond the standard Connect IQ SDK/Eclipse
  plugin (`.project` file present) — build via the Connect IQ SDK CLI or
  Eclipse, not via any script in this repo.

## Repo layout

```
manifest.xml           App manifest: id, version, permissions, supported devices
source/
  GarminelloApp.mc      App entry point; hardcodes the API base URL
  GarminelloApi.mc       All HTTP calls to garminello-web (register/config/boards/board_lists)
  ItemsModel.mc           In-memory model for the currently open board's lists/cards
  RenderTools.mc          Drawing helpers
  delegates/              Input handling per screen (register, board selection, items, playback, menu)
  views/                  UI per screen (register, board selection, items, playback, about, connection error)
resources/
  drawables/, layouts/, menus/, strings/
```

## Key facts / gotchas

- **API base URL is hardcoded** in `GarminelloApp.mc`:
  `https://garminello.herokuapp.com`. There's a commented-out ngrok URL
  next to it from local dev — changing environments means editing this
  constant and rebuilding/republishing the app, there's no runtime config.
- `VERSION` (currently `"0.9"`, in `GarminelloApp.mc`) is sent as a `v`
  query param on every API call; the server currently only logs it.
- The watch caches the last-viewed board + its lists in app properties
  (`board`, `items`) so the app can reopen offline without a network call
  (see `ItemsModel.mc` / `README.md`'s user manual section).
- Registration flow: watch generates an 8-char activation code locally
  (`RegisterDelegate.generateActivationCode`), user enters it on the
  website, watch polls `POST /api/watch/register` until it gets back a
  `uuid`, which is then used for all further calls.
- All API responses come back as HTTP 200 with a `{status, error}` envelope
  on failure — this is deliberate, to work around a Connect IQ SDK
  limitation where non-200 statuses aren't passed through to the app
  (see `ApiCall.onReceive` in `GarminelloApi.mc`, and the matching note in
  `garminello-web`'s `docs/ARCHITECTURE.md`). `status == 456` specifically
  means "(re)register the watch".

## Known risks

Last commit in this repo is from **2016-06-22** — a decade stale relative to
current Connect IQ SDK versions and devices. Before trusting this to still
build/run correctly:
- Confirm the current Connect IQ SDK still supports building for `vivoactive_hr`
  (Garmin periodically drops SDK support for older devices).
- Confirm `https://garminello.herokuapp.com` is actually live — see
  `garminello-web/docs/INTEGRATION_STATUS.md` for why that's in doubt
  (Heroku free dynos were discontinued after this backend's last commit).
