# ============================================================
# 02-git.ps1
# ============================================================

. "$PSScriptRoot\..\modules\Common.ps1"

Write-Step "Git"
Install-WingetPackage -Id 'Git.Git' -Name 'Git'
