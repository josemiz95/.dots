# ============================================================
# main.ps1
# Punto de entrada único. Al formatear el equipo, ejecuta esto
# (como administrador) y elige qué instalar desde el menú.
#
#   Uso:
#     pwsh -ExecutionPolicy Bypass -File .\main.ps1
#
# ============================================================

. "$PSScriptRoot\modules\Common.ps1"

Assert-Elevated

# ---- Definición de grupos ------------------------------------
$devtoolsScripts = [ordered]@{
    "Todo lo anterior (terminal, git, docker, nvm, editores, WSL)" = $null   # opción "instalar todo el grupo"
    "PowerShell 7 + Oh My Posh + Windows Terminal"            = "scripts\01-terminal-setup.ps1"
    "Git"                                                     = "scripts\02-git.ps1"
    "Docker Desktop"                                          = "scripts\03-docker.ps1"
    "NVM for Windows"                                         = "scripts\04-nvm.ps1"
    "VS Code + Visual Studio"                                 = "scripts\05-editors.ps1"
    "WSL 2 + Ubuntu + perfil de Windows Terminal"              = "scripts\06-wsl.ps1"
}

$optionalApps = [ordered]@{
    "NanaZip" = "optional\NanaZip.ps1"
    "Discord" = "optional\Discord.ps1"
}

# ---- Helper: menú de una sola opción --------------------------
function Select-SingleOption {
    param(
        [string]$Title,
        [string[]]$Options,
        [string]$BackLabel = "Volver"
    )

    Write-Host "`n============================================" -ForegroundColor Magenta
    Write-Host " $Title" -ForegroundColor Magenta
    Write-Host "============================================" -ForegroundColor Magenta

    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "  [$($i + 1)] $($Options[$i])"
    }
    Write-Host "  [0] $BackLabel"

    $choice = Read-Host "`nElige una opción"
    if ($choice -match '^\d+$') {
        $n = [int]$choice
        if ($n -eq 0) { return $null }
        if ($n -ge 1 -and $n -le $Options.Count) { return $Options[$n - 1] }
    }

    Write-Host "Opción no válida." -ForegroundColor Red
    return Select-SingleOption -Title $Title -Options $Options -BackLabel $BackLabel
}

# ---- Submenú: Devtools ----------------------------------------
function Show-DevtoolsMenu {
    $names = @($devtoolsScripts.Keys)
    while ($true) {
        $selected = Select-SingleOption -Title "Devtools" -Options $names
        if ($null -eq $selected) { return }

        if ($null -eq $devtoolsScripts[$selected]) {
            foreach ($script in $devtoolsScripts.Values | Where-Object { $_ }) {
                & "$PSScriptRoot\$script"
            }
        } else {
            & "$PSScriptRoot\$($devtoolsScripts[$selected])"
        }
    }
}

# ---- Submenú: Apps opcionales ----------------------------------
function Show-OptionalAppsMenu {
    $names = @($optionalApps.Keys)
    while ($true) {
        $selected = Select-SingleOption -Title "Apps opcionales" -Options $names
        if ($null -eq $selected) { return }

        & "$PSScriptRoot\$($optionalApps[$selected])"
    }
}

# ---- Menú principal ----------------------------------------------
while ($true) {
    $selected = Select-SingleOption -Title "¿Qué quieres instalar?" -Options @("Devtools", "Apps opcionales") -BackLabel "Salir"
    if ($null -eq $selected) { break }

    switch ($selected) {
        "Devtools"        { Show-DevtoolsMenu }
        "Apps opcionales" { Show-OptionalAppsMenu }
    }
}

Write-Host "`n============================================" -ForegroundColor Green
Write-Host " Configuración completa." -ForegroundColor Green
Write-Host " Abre PowerShell 7 (pwsh) y Windows Terminal para ver los cambios." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
