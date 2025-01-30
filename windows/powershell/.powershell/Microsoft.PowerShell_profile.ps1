# Ruta al archivo de configuración del tema de Oh My Posh
$themePath = "$HOME\.oh-my-posh.json"

# Inicializar Oh My Posh con el tema configurado
if (Test-Path $themePath) {
    oh-my-posh init pwsh --config $themePath | Invoke-Expression
} else {
    Write-Host "El archivo de configuración de Oh My Posh no se encontró en: $themePath" -ForegroundColor Red
}

# Importar módulos necesarios
try {
    Import-Module PSReadLine -ErrorAction Stop
    Import-Module -Name Terminal-Icons -ErrorAction Stop
} catch {
    Write-Host "No se pudieron cargar los módulos necesarios: $_" -ForegroundColor Red
}

# Configuración de PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Opcional: Configuración avanzada de PSReadLine
# Set-PSReadLineOption -HistorySearchCursorMovesToEnd
# Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# Set-PSReadLineKeyHandler -Key Tab -Function Complete
