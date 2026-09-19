# ============================================================
# 03-docker.ps1
# Docker Desktop. La instalación es silenciosa, pero el primer
# arranque pedirá aceptar la licencia y (si aplica) activar WSL2.
# ============================================================

. "$PSScriptRoot\..\modules\Common.ps1"

Write-Step "Docker Desktop"
Install-WingetPackage -Id 'Docker.DockerDesktop' -Name 'Docker Desktop'
Write-Host "    Nota: abre Docker Desktop una vez para aceptar la licencia y completar la configuración inicial (WSL2, etc.)." -ForegroundColor DarkYellow
