# ============================================================
# 01-terminal-setup.ps1
# PowerShell 7 + Oh My Posh + módulos + perfil + Windows Terminal
# ============================================================

. "$PSScriptRoot\..\modules\Common.ps1"

$RepoRoot = Resolve-Path "$PSScriptRoot\.."

$ohMyPoshProfile   = "$RepoRoot\.oh-my-posh\custom-posh.json"
$customProfilePath = "$RepoRoot\.powershell\Microsoft.PowerShell_profile.ps1"
$userProfilePath   = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$profileFilePath   = "$RepoRoot\.terminal\terminal-profile.json"
$settingsPath      = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

Write-Step "PowerShell 7"
if (-not (Test-CommandExists 'pwsh')) {
    Install-WingetPackage -Id 'Microsoft.PowerShell' -Name 'PowerShell 7'
} else {
    Write-Skip 'PowerShell 7'
}

Write-Step "Oh My Posh"
Install-WingetPackage -Id 'JanDeDobbeleer.OhMyPosh' -Name 'Oh My Posh'

Write-Step "Módulos de PowerShell (PSReadLine, Terminal-Icons)"
foreach ($module in @('PSReadLine', 'Terminal-Icons')) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "    Instalando módulo: $module..."
        Install-Module -Name $module -Force -Scope AllUsers -AllowClobber -Confirm:$false
        Write-Ok $module
    } else {
        Write-Skip $module
    }
}

Write-Step "Tema personalizado de Oh My Posh"
Copy-Item $ohMyPoshProfile -Destination "$HOME\.oh-my-posh.json" -Force
Write-Ok "Tema copiado a $HOME\.oh-my-posh.json"

Write-Step "Fuente Nerd Font (RobotoMono)"
oh-my-posh font install RobotoMono

Write-Step "Perfil de PowerShell 7"
$profileDir = Split-Path -Parent $userProfilePath
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
Copy-Item $customProfilePath -Destination $userProfilePath -Force
Write-Ok "Perfil copiado a $userProfilePath"

Write-Step "Perfil de Windows Terminal"
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
    $newProfile = Get-Content $profileFilePath | ConvertFrom-Json
    $existingProfile = $settings.profiles.list | Where-Object { $_.guid -eq $newProfile.guid }

    if ($existingProfile) {
        Write-Skip "Perfil de Windows Terminal"
    } else {
        $settings.profiles.list += $newProfile
        $settings.defaultProfile = $newProfile.guid
        $settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Force
        Write-Ok "Perfil de Windows Terminal añadido"
    }
} else {
    Write-Fail "No se encontró settings.json en $settingsPath"
}
