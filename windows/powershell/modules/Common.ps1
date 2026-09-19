# ============================================================
# Common.ps1
# Funciones compartidas por todos los sub-scripts de instalación.
# Se carga con dot-sourcing: . "$PSScriptRoot\..\modules\Common.ps1"
# ============================================================

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Message)
    Write-Host "    OK: $Message" -ForegroundColor Green
}

function Write-Skip {
    param([string]$Message)
    Write-Host "    Ya instalado: $Message" -ForegroundColor Yellow
}

function Write-Fail {
    param([string]$Message)
    Write-Host "    ERROR: $Message" -ForegroundColor Red
}

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

<#
    Assert-Elevated
    Si la sesión actual NO es de administrador, relanza el script que la
    llamó en una nueva consola elevada (pidiendo UAC) y termina la actual.
    Se usa desde main.ps1 como primera línea, antes de instalar nada.
#>
function Assert-Elevated {
    if (Test-IsAdmin) { return }

    Write-Host "Se necesitan permisos de administrador. Relanzando..." -ForegroundColor Yellow

    $exe = if (Get-Command pwsh -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell' }
    Start-Process -FilePath $exe -Verb RunAs -ArgumentList @(
        '-ExecutionPolicy', 'Bypass',
        '-NoExit',
        '-File', "`"$PSCommandPath`""
    )
    exit
}

function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Test-WingetPackageInstalled {
    param([string]$Id)
    $result = winget list --id $Id --exact --accept-source-agreements 2>$null
    return ($LASTEXITCODE -eq 0) -and ($result -match [regex]::Escape($Id))
}

<#
    Install-WingetPackage
    Instala un paquete con winget de forma idempotente.

    -Id            Id exacto del paquete en winget (obligatorio)
    -Name          Nombre legible para los mensajes
    -Interactive   Si se indica, NO se fuerza modo silencioso: se deja que el
                   propio instalador se muestre (útil para Visual Studio,
                   Docker Desktop, etc. donde luego quieres configurar tú mismo)
#>
function Install-WingetPackage {
    param(
        [Parameter(Mandatory = $true)][string]$Id,
        [Parameter(Mandatory = $true)][string]$Name,
        [switch]$Interactive
    )

    if (Test-WingetPackageInstalled -Id $Id) {
        Write-Skip $Name
        return
    }

    Write-Host "    Instalando $Name..."
    $wingetArgs = @('install', '--id', $Id, '--exact', '--source', 'winget', '--accept-package-agreements', '--accept-source-agreements')

    if ($Interactive) {
        $wingetArgs += '--interactive'
    } else {
        $wingetArgs += '--silent'
    }

    winget @wingetArgs

    if ($LASTEXITCODE -eq 0) {
        Write-Ok $Name
    } else {
        Write-Fail "$Name (código de salida $LASTEXITCODE)"
    }
}
