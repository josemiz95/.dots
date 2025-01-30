# Filename: setup-terminal.ps1
# Descripción: Configura PowerShell 7 con Oh My Posh, PSReadLine y Terminal-Icons utilizando perfiles personalizados.

# Variables
$ohMyPoshProfile = "$PSScriptRoot\custom-posh.json"
$customProfilePath = "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"
$userProfilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

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

# 6. Confirmación final
Write-Host "Configuración completa. Abre PowerShell 7 (pwsh) para aplicar los cambios." -ForegroundColor Green
