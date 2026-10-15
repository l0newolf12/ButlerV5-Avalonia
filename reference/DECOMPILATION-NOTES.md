# Avalonia compatibility notes

The reference build was a local VibeSkua Avalonia test build's `Build` directory.

Only public contracts and the relevant host-service implementations were inspected.
No decompiled Skua source is included in this project.

## Findings

- Target runtime: `.NETCoreApp,Version=v10.0`.
- The `ISkuaPlugin`, `IPluginHelper`, `IPluginContainer`, and gameplay interfaces remain
  compatible with the existing ButlerV5 core.
- The WPF-only `Skua.WPF.CustomWindow` has no Avalonia equivalent.
- Avalonia Skua provides `IDispatcherService` and `IDialogService` through the plugin's
  `IServiceProvider`.
- Startup plugin initialization runs on a background task. Menu registration must be
  posted to the UI dispatcher so the menu subscriber exists and its collection is only
  changed on the UI thread.
- In the supplied test build, startup `AddPluginMenuItemMessage` delivery can still be
  lost even after dispatch. ButlerV5 therefore uses the public helper to construct its
  normal command, then reflectively inserts that same command into
  `MainMenuViewModel.Plugins` only when it is absent. This is a targeted workaround for
  the host bug and does not reference private Skua types at compile time.
- Plugin windows therefore derive directly from `Avalonia.Controls.Window`, use the
  host's `skua`/`skua-button` style classes, and use the public dispatcher/dialog
  services rather than referencing private `Skua.App.Avalonia` types.

The project references the assemblies in the target build with `Private=false`, so the
plugin output contains only `ButlerV5 Avalonia.dll` and uses the copies already loaded by
Skua.
