# ============================================================
# 04-nvm.ps1
# NVM for Windows (Node Version Manager)
# ============================================================

. "$PSScriptRoot\..\modules\Common.ps1"

Write-Step "NVM for Windows"
Install-WingetPackage -Id 'CoreyButler.NVMforWindows' -Name 'NVM for Windows'
Write-Host "    Nota: abre una terminal nueva y ejecuta 'nvm install lts' + 'nvm use lts' para tener Node listo." -ForegroundColor DarkYellow
