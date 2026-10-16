# ButlerV5 Avalonia

Current public version: **1.2.7**, matching ButlerV5 for WPF.

Download the compiled DLL from [GitHub Releases](https://github.com/l0newolf12/ButlerV5-Avalonia/releases).
Local builds write to `dist/`, which is excluded from Git.

This is the Avalonia-native port of [ButlerV5](https://github.com/l0newolf12/ButlerV5) for the supplied VibeSkua/Skua Avalonia
test build. It keeps the original follow, summon, sync-file, combat, quest-bypass,
quest-clone, parking, class, AntiLag, and logging behavior while replacing all WPF UI
and `Skua.WPF` dependencies with Avalonia controls and public Skua services.

The Avalonia and original ButlerV5 editions intentionally use the same
`%APPDATA%\Skua\character_locations` sync protocol, so accounts running either edition
can see one another. Do not load both plugin DLLs in the same Skua process.
The roster shows each account's equipped class beside its map and server when the
account publishes `class=`; older plugin versions simply omit the class label.
Messages sent to Skua's scripting log use anonymous account roles and counts.
ButlerV5's own debug viewer, saved logs, and exports retain names for diagnostics.
Each location file now includes `offgoto=1` while the account's AQW **Enable Goto**
preference is off (`offgoto=0` otherwise). Both editions read the flag and join
the master's map-room directly when goto is disabled.
For the master's own house, the follower sends a house request using the master's
username and verifies the resulting room instance. It parks if the master is in
another player's house and the instance does not match.

## Layout

- `src/ButlerV5.Avalonia/` - plugin source and project file
- `reference/DECOMPILATION-NOTES.md` - API compatibility findings from the supplied build
- `build.ps1` - builds the plugin
- `deploy.ps1` - builds and copies the DLL to the supplied build's `plugins` folder

## Build

Close Skua if its plugin DLL is already loaded, then pass the path to your
VibeSkua Avalonia `Build` directory:

```powershell
.\build.ps1 -SkuaBuild "D:\path\to\VibeSkua\Build"
```

You can also set `SKUA_AVALONIA_BUILD` to that directory and run `.\build.ps1`
without arguments.

To build with `dotnet` directly:

```powershell
dotnet build .\src\ButlerV5.Avalonia\ButlerV5.Avalonia.csproj -c Release -p:SkuaAvaloniaBuild="D:\path\to\VibeSkua\Build"
```

The ready-to-install output is `dist\ButlerV5 Avalonia.dll`.

## Deploy

```powershell
.\deploy.ps1 -SkuaBuild "D:\path\to\VibeSkua\Build"
```

This copies only `ButlerV5 Avalonia.dll`; Avalonia and Skua assemblies are provided by
the host application and are not bundled with the plugin. The Avalonia client scans
`%APPDATA%\Skua\plugins` rather than the `Build\plugins` directory. Close every running
Skua instance before replacing the DLL, then restart the client.
