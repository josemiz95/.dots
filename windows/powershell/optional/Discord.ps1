# ============================================================
# Discord.ps1
# ============================================================

. "$PSScriptRoot\..\modules\Common.ps1"

Write-Step "Discord"
Install-WingetPackage -Id 'Discord.Discord' -Name 'Discord'
