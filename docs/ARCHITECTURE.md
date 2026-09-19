# Architecture

## Screen / flow map

```
GarminelloApp.getInitialView()
  -> if cached board+items exist:  ItemsView (offline-capable)
  -> else:                         RegisterView
       RegisterDelegate.tryConfig() -> GET /api/watch/config/:watch_uuid
         200            -> BoardSelectionView
         456            -> generate activation code, show it, wait for tap -> tryRegister()
                            -> POST /api/watch/register -> store uuid -> tryConfig() again
         other          -> ConnectionErrorView

BoardSelectionView (+ BoardSelectionViewDelegate)
  -> GET /api/watch/boards/:watch_uuid   (on init)
  -> tap a board -> ItemsView(ItemsModel(board, items=null))

ItemsView (+ ItemsViewDelegate) / ItemsModel
  -> if items == null: GET /api/watch/board_lists/:watch_uuid/:board_id
  -> renders lists of cards; menu action can push into PlaybackView to
     run a list as a timed sequence using each card's parsed `t` (seconds)
```

## `GarminelloApi.mc` — server calls

| Function | Method | Path | Notes |
|---|---|---|---|
| `registerWatch` | POST | `/api/watch/register` | Sends `activation_code`, `type: "vivoactive_hr"`, and a `profile` dict built from Garmin `UserProfile` (activity class, birth year, gender, height, resting HR, step lengths, weight) |
| `getConfig` | GET | `/api/watch/config/:watch_id` | Polled on every cold start before showing any board UI |
| `getBoards` | GET | `/api/watch/boards/:watch_id` | Populates `BoardSelectionView` |
| `getBoard` | GET | `/api/watch/board_lists/:watch_id/:board_id` | Populates `ItemsModel` for a chosen board |

`watch_id` here is actually the `uuid` returned by `registerWatch`, stored
as the `watch_id` app property — naming inherited from the original code.

All calls go through `get_or_post`, which appends `v=<VERSION>` as a query
param and always issues a JSON request (`Comm.makeJsonRequest`) regardless
of GET/POST.

## Response handling (`ApiCall.onReceive`)

The Connect IQ `Communications` module only reliably delivers HTTP status
`200` end-to-end to app code for this SDK version; garminello-web works
around this by *always* responding `200` and embedding the real status in
the JSON body as `{status, error}`. `ApiCall.onReceive` unwraps that:

```
if data is a Dictionary with a "status" key:
    status = data["status"]
    data   = data["error"]

status == 456        -> localized "register watch" message
status == 0 or -300   -> localized "connection error" message (network-level failure)
status < 0             -> localized generic API error, with the numeric code appended
```

Any caller-supplied callback then receives `(status, data)` with `status`
being the *logical* status (which may differ from the literal HTTP status),
and `data` being either the payload or a human-readable error string.

## Data shapes consumed from the API

- `getBoards` → array of `{id, name}` (Trello board id/name, `fields: name`
  requested server-side).
- `getBoard`/`board_lists` → array of lists: `{name, cards: [{name, t?}]}`.
  Card `id` is stripped server-side (`delete card.id`) since it's unused on
  the watch. `t` (seconds) is present only when the card name contained a
  `[Xm Ys]`-style duration, which the server parses out and strips from the
  displayed `name`.

See `garminello-web/docs/ARCHITECTURE.md` for the server-side implementation
of these endpoints and the exact Trello REST calls they proxy.
