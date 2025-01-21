oh-my-posh init pwsh --config 'C:\Users\josr\AppData\Local\Programs\oh-my-posh\themes\custom-z.omp.json' | Invoke-Expression
Import-Module PSReadLine
Import-Module -Name Terminal-Icons
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
#Set-PSReadLineOption -HistorySearchCursorMovesToEnd
#Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
#Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#Set-PSReadLineKeyHandler -Key Tab -Function Complete