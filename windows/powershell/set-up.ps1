# OhMyPosh
$ohMyPoshProfile = "$PSScriptRoot\.oh-my-posh\custom-posh.json"

# PowerShell
$customProfilePath = "$PSScriptRoot\.powershell\Microsoft.PowerShell_profile.ps1"
$userProfilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# Windows Terminal
$profileFilePath = "$PSScriptRoot\.terminal\terminal-profile.json"
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Install PowerShell (if necessary)
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing PowerShell 7..."
    winget install --id Microsoft.PowerShell --source winget
} else {
    Write-Host "PowerShell 7 is already installed."
}

# Install Oh My Posh
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Oh My Posh..."
    winget install JanDeDobbeleer.OhMyPosh -e --source winget
} else {
    Write-Host "Oh My Posh is already installed."
}

# Verify and install PSReadLine and Terminal-Icons modules
Write-Host "Verifying necessary modules..."
$requiredModules = @("PSReadLine", "Terminal-Icons")

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing module: $module..."
        Install-Module -Name $module -Force -Scope AllUsers -AllowClobber -Confirm:$false
    } else {
        Write-Host "Module $module is already installed."
    }
}

# Configure Oh My Posh with the custom theme
if (Test-Path $ohMyPoshProfile) {
    Copy-Item $ohMyPoshProfile -Destination "$HOME\.oh-my-posh.json" -Force
} else {
    Write-Host "Error: The Oh My Posh theme file was not found at $ohMyPoshProfile."
    Exit 1
}

# Install FiraCode Nerd Font Mono
oh-my-posh font install RobotoMono

# Configure PowerShell 7 profile
$profileDir = Split-Path -Parent $userProfilePath
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}
if (Test-Path $customProfilePath) {
    Copy-Item $customProfilePath -Destination $userProfilePath -Force
} else {
    Write-Host "Error: The profile file was not found at $customProfilePath."
    Exit 1
}

# Add profile to Windows Terminal
if (Test-Path $profileFilePath) {
    Write-Host "Adding profile..."
    
    if (Test-Path $settingsPath) {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $newProfile = Get-Content $profileFilePath | ConvertFrom-Json
        $existingProfile = $settings.profiles.list | Where-Object { $_.guid -eq $newProfile.guid }

        if ($existingProfile) {
            Write-Host "The profile already exists in settings.json." -ForegroundColor Yellow
        } else {
            $settings.profiles.list += $newProfile
            $settings.defaultProfile = $newProfile.guid
            $settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Force
            Write-Host "Profile successfully added from the JSON file." -ForegroundColor Green
        }
    } else {
        Write-Host "The settings.json file was not found at the specified path." -ForegroundColor Red
        Exit 1
    }
} else {
    Write-Host "The profile file was not found at the specified path: $profileFilePath" -ForegroundColor Red
    Exit 1
}

# End
Write-Host "Configuration complete. Open PowerShell 7 (pwsh) and Windows Terminal to apply the changes." -ForegroundColor Green
