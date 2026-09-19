# ============================================================
# 05-editors.ps1
# Visual Studio Code -> instalación silenciosa (solo el editor).
# Visual Studio      -> se deja el instalador visible para elegir
#                       cargas de trabajo, iniciar sesión, etc. a mano.
# ============================================================

. "$PSScriptRoot\..\modules\Common.ps1"

Write-Step "Visual Studio Code"
Install-WingetPackage -Id 'Microsoft.VisualStudioCode' -Name 'Visual Studio Code'

Write-Step "Visual Studio 2022 Community"
Write-Host "    Se abrirá el instalador de Visual Studio para que elijas cargas de trabajo e inicies sesión manualmente." -ForegroundColor DarkYellow
Install-WingetPackage -Id 'Microsoft.VisualStudio.2022.Community' -Name 'Visual Studio 2022 Community' -Interactive
