# Garminello watch app — Connect IQ / Monkey C

A Garmin Connect IQ watch app (Monkey C) that talks to a separate `garminello-web`
backend. See [README.md](README.md) for app architecture and behavior.

## Checking that the project compiles

There's no test suite — the equivalent check is a clean `monkeyc` build. The
Connect IQ SDK lives outside the repo, managed by the Monkey C VS Code extension
(`garmin.monkey-c`) or the standalone Garmin SDK Manager:

```bash
SDK="$(cat "$HOME/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg")"
"$SDK/bin/monkeyc" --version
```

Compiling needs a developer key (`.der`, PKCS8 DER, unencrypted). Generate a
throwaway one for local checks — never commit it:

```bash
openssl genrsa -out /tmp/devkey.pem 4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in /tmp/devkey.pem -out /tmp/devkey.der -nocrypt
```

Then, from the repo root:

```bash
"$SDK/bin/monkeyc" -f monkey.jungle -d vivoactive_hr -o /tmp/garminello.prg -y /tmp/devkey.der
```

`-d <device>` can be any product id from `manifest.xml`'s `<iq:products>` list. The
type checker runs over the whole project no matter which single device is targeted, so
one device is enough to surface source errors — but device-id validity itself (does
this SDK know about `fenix9pro47mm`, etc.) only gets checked at compile time, so an
outdated SDK will throw `Invalid device id found in the application manifest` even
though the actual source is fine. If you see that error, the fix is a newer SDK, not a
code change.

## Monkey C type-checker gotchas hit in this codebase

These caused real compile failures (fixed in commit `514784c`) and are easy to
reintroduce:

- **`BehaviorDelegate`/`InputDelegate`/`ConfirmationDelegate`/`MenuInputDelegate`
  callbacks must return `Boolean` on every code path** (`onTap`, `onKey`, `onSwipe`,
  `onResponse`, `onMenuItem` when overriding a `Boolean`-returning base). A bare
  `return;` or falling off the end of the function fails to compile.
- **`onTap(evt)` on `InputDelegate` takes one parameter** (the click event) — a
  zero-arg override is an "different number of parameters" error.
- **`WatchUi.Menu.addItem(label, identifier)` requires `identifier` to be a compile-time
  `Symbol`**, not a `Number`. Monkey C symbols can't be constructed dynamically, so
  dynamic menu items (e.g. one per board list) need a fixed pool of symbols declared up
  front and indexed by position — see `ItemsViewDelegate.LIST_ITEM_IDS`.
- **`findDrawableById(...)` returns the generic `Drawable` type**, which doesn't
  statically expose `setText()`. Cast to `Ui.Text` first:
  `(findDrawableById("foo") as Ui.Text).setText(...)`.
- **Class-level `const` used from a `static function` of the same class needs
  `static const`**, not just `const` — otherwise it's treated as an instance member and
  isn't visible from static context (or from other classes referencing it as
  `ClassName.CONST`).
- **Callback methods passed to `Communications.makeJsonRequest` must have an explicit
  signature matching what the API expects** (`Method(responseCode as Number, data as
  Null or Dictionary or String or PersistedContent.Iterator) as Void`) — an untyped
  callback method infers as `Method(... as Any) as Any` and fails the parameter-type
  check.

## Device support

`manifest.xml` lists `vivoactive_hr` plus the fenix7/8/9 and epix2 device families.
When adding new device ids, confirm the installed SDK actually recognizes them (see
above) before assuming a manifest change alone is sufficient.
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
