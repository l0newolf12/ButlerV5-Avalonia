param(
    [string]$Configuration = "Release",
    [string]$SkuaBuild = $env:SKUA_AVALONIA_BUILD
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($SkuaBuild)) {
    throw "Set SKUA_AVALONIA_BUILD or pass -SkuaBuild with your VibeSkua Avalonia Build directory."
}
$project = Join-Path $PSScriptRoot "src\ButlerV5.Avalonia\ButlerV5.Avalonia.csproj"

dotnet build $project -c $Configuration -p:SkuaAvaloniaBuild="$SkuaBuild"

if ($LASTEXITCODE -ne 0) {
    throw "ButlerV5 Avalonia build failed."
}

$output = Join-Path $PSScriptRoot "src\ButlerV5.Avalonia\bin\$Configuration\ButlerV5 Avalonia.dll"
$dist = Join-Path $PSScriptRoot "dist"
New-Item -ItemType Directory -Force -Path $dist | Out-Null
Copy-Item -LiteralPath $output -Destination (Join-Path $dist "ButlerV5 Avalonia.dll") -Force
Write-Host "Built: $output"
Write-Host "Ready-to-install DLL: $(Join-Path $dist 'ButlerV5 Avalonia.dll')"
