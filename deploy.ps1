param(
    [string]$Configuration = "Release",
    [string]$SkuaBuild = $env:SKUA_AVALONIA_BUILD,
    [string]$PluginsDirectory = (Join-Path $env:APPDATA "Skua\plugins")
)

$ErrorActionPreference = "Stop"
& (Join-Path $PSScriptRoot "build.ps1") -Configuration $Configuration -SkuaBuild $SkuaBuild

$source = Join-Path $PSScriptRoot "dist\ButlerV5 Avalonia.dll"
New-Item -ItemType Directory -Force -Path $PluginsDirectory | Out-Null
Copy-Item -LiteralPath $source -Destination (Join-Path $PluginsDirectory "ButlerV5 Avalonia.dll") -Force
Write-Host "Deployed to: $PluginsDirectory"
