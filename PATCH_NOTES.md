# ButlerV5 Patch Notes

## ButlerV5 Avalonia 1.2.6 / ButlerV5 1.2.6 — October 15, 2026

The public Avalonia release now shares the WPF plugin's version number; earlier
Avalonia test builds used a separate numbering sequence.

### Changed

- The roster now shows each account's currently equipped class beside its map and server, and refreshes when the class changes.
- Both editions publish the class name through the shared `character_locations` sync file. Accounts running an older version remain visible without a class label.
- Class sampling runs every two seconds rather than on every 250 ms location poll, avoiding repeated inventory reads.
- Build output in `dist/` is no longer tracked in Git. The build script still produces the ready-to-install DLL there for release distribution.

### Validation

- Both editions compiled in Release configuration with zero warnings and zero errors. No live-client test was performed here.

## ButlerV5 1.2.5 — September 30, 2026

### Fixed

- Own-house parking now checks AQW's persistent `CharID`, which matches the `house-<id>` room. Skua's `Player.ID` is a session UID; using it made a successful house join look like a failure and eventually sent the butler to whitemap.
- The same source fix was present in the Avalonia test build numbered 1.3.3.

## ButlerV5 Avalonia 1.3.3 / ButlerV5 1.2.4 — September 24, 2026

### Fixed after house-follow testing

- House parking attempted to distinguish the butler's own house from someone else's, but its initial ID lookup used Skua's session UID. Version 1.2.5 corrects that lookup.
- A butler parked in someone else's house will try to return home when released. If it cannot confirm arrival, parking falls back to whitemap.

### Changed

- Each account now publishes `offgoto=1` in its `character_locations` file when AQW's **Enable Goto** preference is off, and `offgoto=0` when it is on. The plugin reads the game's `uoPref.bGoto` value while broadcasting.
- Butlers following a master with goto disabled directly join the master's synchronized map-room instead of sending `/goto` or stopping the follow. Once in the room, they continue normal cell jumps and combat.
- If AQW rejects a goto before the sync file reflects the new setting, the butler switches to direct joins. It resumes goto after the master publishes `offgoto=0`.
- The **Always goto the master** option skips goto while the master has it disabled. Direct joins are rate-limited, and inaccessible destinations are parked after three attempts until the master moves.
- Direct travel to the master's own house uses the house-join packet, then waits for the exact `house-<room>` from the master's file. A different house instance is reported and parked until the master moves; no house-owner field was added.
- Ordinary room changes on the same map now use Skua's direct transfer packet. Skua's higher-level `Map.Join` skips its transfer loop when the map name is already the same, even if the room number differs.

### Validation

- Both editions compile in Release configuration. Live-client behavior has not been verified here.

## ButlerV5 Avalonia 1.3.2 / ButlerV5 1.2.3 — September 5, 2026

### Fixed

- Fixed a deterministic Skua skill-engine lock that could leave a butler using only basic auto-attacks. Butler now resumes a paused skill worker before calling `Stop()`, allowing Skua's worker to leave its pause wait, observe cancellation, and shut down.
- Fixed Butler reporting skills as active merely because `StartAdvanced()` returned. It now records Skua's actual `TimerRunning` and `IsPaused` values.
- Fixed failed pause and resume calls being recorded as successful. Butler now verifies the resulting Skua state after each operation.
- Added automatic recovery when Skua's skill worker exits silently. The combat loop reconciles its cached state with Skua and restarts the worker when necessary.
- Fixed reconnect handling that assumed the previous skill worker had already died. Butler now safely shuts down any surviving or paused worker before preparing the new class rotation.
- Parking now force-disables both `AggroMonsters` and `AggroAllMonsters` throughout parking retries and while the butler remains parked. The values are deliberately not restored automatically.

### Behavior retained

- Skills remain active when the master and butler are in the same map and room instance, even when they occupy different cells.
- Skills pause while travelling to a different map or room instance and resume after the butler reaches the master.
- Skill rotations still start lazily after arrival, avoiding unnecessary start/stop cycles during initial travel.

### Diagnostics

- Skill lifecycle messages now include the actual `TimerRunning` and `IsPaused` state reported by Skua.
- Added explicit diagnostic messages when `StartAdvanced()`, `Pause()`, or `Resume()` does not produce the expected state.

### Validation

- ButlerV5 Avalonia compiled successfully in Release configuration with zero warnings and zero errors.
- No live-client smoke test was performed; runtime verification is left to the plugin user.
