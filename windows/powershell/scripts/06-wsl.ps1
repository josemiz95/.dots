# ============================================================
# 06-wsl.ps1
# Instala Ubuntu en WSL y añade su perfil a Windows Terminal,
# abierto en el directorio del usuario de Windows.
# ============================================================

. "$PSScriptRoot\..\modules\Common.ps1"

$repoRoot = Resolve-Path "$PSScriptRoot\.."
$profilePath = Join-Path $repoRoot '.terminal\wsl-profile.json'
$settingsPath = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
$distribution = 'Ubuntu'

Write-Step 'WSL 2 + Ubuntu'
$installed = @(wsl.exe --list --quiet 2>$null | ForEach-Object { $_.Trim() })
if ($installed -contains $distribution) {
    Write-Skip 'Ubuntu en WSL'
} else {
    Write-Host '    Instalando Ubuntu en WSL...'
    wsl.exe --install --distribution $distribution --no-launch
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Ubuntu en WSL (código de salida $LASTEXITCODE)"
        return
    }
    Write-Ok 'Instalación de WSL solicitada'
    Write-Host '    Reinicia Windows si lo solicita. Después abre Ubuntu una vez para crear tu usuario Linux.' -ForegroundColor DarkYellow
}

Write-Step 'Windows Terminal'
Install-WingetPackage -Id 'Microsoft.WindowsTerminal' -Name 'Windows Terminal'

# El archivo de configuración puede no existir hasta la primera apertura de Terminal.
$settingsDir = Split-Path -Parent $settingsPath
if (-not (Test-Path $settingsDir)) {
    New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
}
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
} else {
    $settings = [pscustomobject]@{ profiles = [pscustomobject]@{ list = @() } }
}
if (-not $settings.profiles) {
    $settings | Add-Member -NotePropertyName profiles -NotePropertyValue ([pscustomobject]@{ list = @() }) -Force
}
if (-not $settings.profiles.list) {
    $settings.profiles | Add-Member -NotePropertyName list -NotePropertyValue @() -Force
}

$profile = Get-Content $profilePath -Raw | ConvertFrom-Json
$windowsHome = $env:USERPROFILE -replace '\\', '/'
$drive = $windowsHome.Substring(0, 1).ToLowerInvariant()
$wslHome = "/mnt/$drive$($windowsHome.Substring(2))"
$profile.commandline = $profile.commandline.Replace('__WINDOWS_HOME_WSL__', $wslHome)

$existing = @($settings.profiles.list | Where-Object { $_.guid -eq $profile.guid })
if ($existing.Count -gt 0) {
    $existing[0].commandline = $profile.commandline
    $existing[0].name = $profile.name
    $existing[0].hidden = $false
    Write-Ok 'Perfil Ubuntu actualizado'
} else {
    $settings.profiles.list = @($settings.profiles.list) + @($profile)
    Write-Ok 'Perfil Ubuntu añadido'
}

if (Test-Path $settingsPath) {
    Copy-Item $settingsPath "$settingsPath.before-wsl.bak" -Force
}
$settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Encoding utf8
Write-Ok "Perfil Ubuntu disponible: $wslHome"
