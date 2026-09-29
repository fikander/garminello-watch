# Garminello

A Garmin Connect IQ watch app for [Garminello](https://garminello.herokuapp.com) — a Trello-style
board viewer. The watch pairs with the Garminello web service via a one-time activation
code, then lets you browse boards, lists and cards, and "play back" a list as a timed
sequence (useful for things like workout circuits or timed routines).

## App flow

- **`GarminelloApp`** (`source/GarminelloApp.mc`) — entry point. If a board/list was
  previously cached in `Storage`, it jumps straight to `ItemsView`; otherwise it starts
  at `RegisterView` to pair the watch with the web service.
- **`GarminelloApi`** (`source/GarminelloApi.mc`) — thin wrapper around
  `Toybox.Communications.makeJsonRequest` for talking to the Garminello backend
  (register watch, fetch config/boards/lists).
- **Views/delegates** (`source/views`, `source/delegates`) — `RegisterView` (pairing),
  `BoardSelectionView` (choose a board), `ItemsView`/`ListView` (browse lists/cards),
  `PlaybackView` (timed playback of a list), `AboutView`, `ConnectionErrorView`.
- **`RenderTools`** (`source/RenderTools.mc`) — the original layout was hand-tuned for
  the VivoActive HR's 148x205 display; this scales all coordinates proportionally to
  whatever the actual device's screen size is.

## Requirements

- **Garmin Connect IQ SDK** — this project needs an SDK version new enough to know
  about the fenix7/8/9 and epix2 device families listed in `manifest.xml` (SDK 6.2.1
  from 2023, for example, predates fenix8/9 and will fail with `Invalid device id`
  errors). Manage SDKs either via the standalone Garmin SDK Manager, or via the
  **Monkey C** VS Code extension's *"Monkey C: Manage SDKs"* command.
- A **developer key** (`.der` file) to sign builds — see below.

## Building / compiling

The project is defined by `monkey.jungle` (which just points at `manifest.xml`).
Compile a single device with `monkeyc` directly, e.g.:

```bash
SDK="$(cat "$HOME/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg")"
"$SDK/bin/monkeyc" -f monkey.jungle -d fenix7 -o /tmp/garminello.prg -y /path/to/developer_key.der
```

Swap `-d fenix7` for any product id listed in `manifest.xml` (`vivoactive_hr`,
`fenix7*`, `fenix8*`, `fenix9*`, `epix2*`, ...). `BUILD SUCCESSFUL` means it compiled
clean; the compiler runs its type checker across the whole project regardless of which
single device you target, so any target is enough to catch source-level errors.

### Generating a developer key

If you don't already have one:

```bash
openssl genrsa -out developer_key.pem 4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in developer_key.pem -out developer_key.der -nocrypt
```

Keep this key private and out of version control — it's your app's signing identity.

### Running in the simulator

Use the Connect IQ Simulator (bundled with the SDK, `bin/ConnectIQ.app` on macOS) or
the Monkey C VS Code extension's build/run commands, which wrap the same `monkeyc` /
`monkeydo` tools.

## Backend

The watch app talks to the `garminello-web` service (a separate repository) at
`https://garminello.herokuapp.com`. Pairing works via an activation code shown on the
watch, entered on the web app.
