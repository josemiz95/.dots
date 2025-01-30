# Filename: setup-terminal.ps1
# Descripción: Configura PowerShell 7 con Oh My Posh, PSReadLine y Terminal-Icons utilizando perfiles personalizados.

# Variables
$ohMyPoshProfile = "$PSScriptRoot\custom-posh.json"
$customProfilePath = "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"
$userProfilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$profileFilePath = "$PSScriptRoot\terminal-profile.json"  # Ruta del archivo JSON con el perfil

# Ruta del archivo settings.json de Windows Terminal
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# 1. Instalar PowerShell (si es necesario)
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando PowerShell 7..."
    winget install --id Microsoft.PowerShell --source winget
} else {
    Write-Host "PowerShell 7 ya está instalado."
}

# 2. Instalar Oh My Posh
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Oh My Posh..."
    winget install JanDeDobbeleer.OhMyPosh -e --source winget
} else {
    Write-Host "Oh My Posh ya está instalado."
}

# 3. Verificar e instalar módulos PSReadLine y Terminal-Icons
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

# 4. Configurar el perfil de PowerShell 7
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

# 5. Configurar Oh My Posh con el tema personalizado
if (Test-Path $ohMyPoshProfile) {
    Copy-Item $ohMyPoshProfile -Destination "$HOME\.oh-my-posh.json" -Force
} else {
    Write-Host "Error: No se encontró el archivo del tema de Oh My Posh en $ohMyPoshProfile."
    Exit 1
}

# 6. Instalar FiraCode Nerd Font Mono
& ".\install-nerd.ps1"

# 7. Agregar el perfil a Windows Terminal desde el archivo JSON
if (Test-Path $profileFilePath) {
    Write-Host "Agregando perfil desde el archivo JSON..."
    
    # Leer el contenido actual de settings.json
    if (Test-Path $settingsPath) {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
        
        # Leer el perfil desde el archivo JSON
        $newProfile = Get-Content $profileFilePath | ConvertFrom-Json
        
        # Comprobar si el perfil ya existe
        $existingProfile = $settings.profiles.list | Where-Object { $_.guid -eq $newProfile.guid }
        if ($existingProfile) {
            Write-Host "El perfil ya existe en settings.json." -ForegroundColor Yellow
        } else {
            # Agregar el nuevo perfil a la lista de perfiles
            $settings.profiles.list += $newProfile
            # Guardar los cambios en settings.json sin romper la estructura
            $settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Force
            Write-Host "Perfil agregado exitosamente desde el archivo JSON." -ForegroundColor Green
        }
    } else {
        Write-Host "No se encontró el archivo settings.json en la ruta especificada." -ForegroundColor Red
        Exit 1
    }
} else {
    Write-Host "El archivo de perfil no se encontró en la ruta especificada: $profileFilePath" -ForegroundColor Red
    Exit 1
}

# 8. Confirmación final
Write-Host "Configuración completa. Abre PowerShell 7 (pwsh) y Windows Terminal para aplicar los cambios." -ForegroundColor Green
