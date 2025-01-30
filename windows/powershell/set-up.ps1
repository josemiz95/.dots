# OhMyPosh
$ohMyPoshProfile = "$PSScriptRoot\.oh-my-posh\custom-posh.json"

# PowerShell
$customProfilePath = "$PSScriptRoot\.powershell\Microsoft.PowerShell_profile.ps1"
$userProfilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# Windows Terminal
$profileFilePath = "$PSScriptRoot\.terminal\terminal-profile.json"
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Instalar PowerShell (si es necesario)
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando PowerShell 7..."
    winget install --id Microsoft.PowerShell --source winget
} else {
    Write-Host "PowerShell 7 ya está instalado."
}

# Instalar Oh My Posh
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Oh My Posh..."
    winget install JanDeDobbeleer.OhMyPosh -e --source winget
} else {
    Write-Host "Oh My Posh ya está instalado."
}

# Verificar e instalar módulos PSReadLine y Terminal-Icons
Write-Host "Verificando módulos necesarios..."
$requiredModules = @("PSReadLine", "Terminal-Icons")

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Instalando módulo: $module..."
        Install-Module -Name $module -Force -Scope AllUsers -AllowClobber -Confirm:$false
    } else {
        Write-Host "Módulo $module ya está instalado."
    }
}

# Configurar Oh My Posh con el tema personalizado
if (Test-Path $ohMyPoshProfile) {
    Copy-Item $ohMyPoshProfile -Destination "$HOME\.oh-my-posh.json" -Force
} else {
    Write-Host "Error: No se encontró el archivo del tema de Oh My Posh en $ohMyPoshProfile."
    Exit 1
}

# Instalar FiraCode Nerd Font Mono
oh-my-posh font install RobotoMono

# Configurar el perfil de PowerShell 7
$profileDir = Split-Path -Parent $userProfilePath
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}
if (Test-Path $customProfilePath) {
    Copy-Item $customProfilePath -Destination $userProfilePath -Force
} else {
    Write-Host "Error: No se encontró el archivo de perfil en $customProfilePath."
    Exit 1
}

# Agregar el perfil a Windows Terminal
if (Test-Path $profileFilePath) {
    Write-Host "Agregando perfil..."
    
    if (Test-Path $settingsPath) {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $newProfile = Get-Content $profileFilePath | ConvertFrom-Json
        $existingProfile = $settings.profiles.list | Where-Object { $_.guid -eq $newProfile.guid }

        if ($existingProfile) {
            Write-Host "El perfil ya existe en settings.json." -ForegroundColor Yellow
        } else {
            $settings.profiles.list += $newProfile
            $settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Force
            Write-Host "Perfil agregado exitosamente desde el archivo JSON." -ForegroundColor Green
            $settings.defaultProfile = $newProfile.guid
        }
    } else {
        Write-Host "No se encontró el archivo settings.json en la ruta especificada." -ForegroundColor Red
        Exit 1
    }
} else {
    Write-Host "El archivo de perfil no se encontró en la ruta especificada: $profileFilePath" -ForegroundColor Red
    Exit 1
}

# End
Write-Host "Configuración completa. Abre PowerShell 7 (pwsh) y Windows Terminal para aplicar los cambios." -ForegroundColor Green
