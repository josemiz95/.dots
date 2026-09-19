# ============================================================
# NanaZip.ps1
# ============================================================

. "$PSScriptRoot\..\modules\Common.ps1"

Write-Step "NanaZip"
Install-WingetPackage -Id 'NanaZip.NanaZip' -Name 'NanaZip'
