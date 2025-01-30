Write-Host "Instalando la fuente FiraCode Nerd Font Mono..." -ForegroundColor Yellow
& ([scriptblock]::Create((Invoke-WebRequest 'https://to.loredo.me/Install-NerdFont.ps1'))) -Confirm:$false -Name fira-code -Scope AllUsers
Write-Host "Fuente FiraCode Nerd Font Mono instalada correctamente." -ForegroundColor Green

# Define the location to store the font
# $FontFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\FiraCode-NerdFont"
# $FontUrlApi = "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"

# # Create the folder if it doesn't exist
# if (-not (Test-Path -Path $FontFolder)) {
#     New-Item -Path $FontFolder -ItemType Directory | Out-Null
# }

# # Get the latest release data from GitHub API
# $ReleaseData = Invoke-RestMethod -Uri $FontUrlApi -Headers @{ "User-Agent" = "PowerShell" }

# # Extract the URL for the FiraCode zip file from the release assets
# $FiraCodeAsset = $ReleaseData.assets | Where-Object { $_.name -like "FiraCode.zip" }
# $FontUrl = $FiraCodeAsset.browser_download_url

# # Temporary location to store the zip file
# $ZipPath = "$env:TEMP\FiraCode.zip"

# # Download the FiraCode Nerd Font zip file
# Invoke-WebRequest -Uri $FontUrl -OutFile $ZipPath

# # Unzip the font files into the folder
# Expand-Archive -Path $ZipPath -DestinationPath $FontFolder

# # Clean up the zip file
# Remove-Item -Path $ZipPath

# # Install the font
# $FontFiles = Get-ChildItem -Path $FontFolder -Recurse -Filter *.ttf
# foreach ($FontFile in $FontFiles) {
#     # Copy font to Windows Fonts directory
#     $Destination = "C:\Windows\Fonts\$($FontFile.Name)"
#     Copy-Item -Path $FontFile.FullName -Destination $Destination -Force
# }

# Remove-Item -Path $FontFolder -Recurse -Force

# Write-Host "FiraCode Nerd Font has been installed successfully!"
