# windows-setup

Automatiza la puesta a punto de un Windows recién formateado.

## Estructura

```
windows-setup/
├── main.ps1                  <- Punto de entrada. Ejecuta esto.
├── modules/
│   └── Common.ps1             <- Funciones compartidas (idempotencia, logging)
├── scripts/                   <- Instalaciones obligatorias, en orden
│   ├── 01-terminal-setup.ps1  <- PowerShell 7, Oh My Posh, módulos, perfil, Windows Terminal
│   ├── 02-git.ps1
│   ├── 03-docker.ps1
│   ├── 04-nvm.ps1
│   ├── 05-editors.ps1         <- VS Code (silencioso) + Visual Studio (instalador visible)
│   └── 06-wsl.ps1             <- WSL 2, Ubuntu y perfil de Windows Terminal
├── optional/                  <- Se eligen desde el menú de main.ps1
│   ├── NanaZip.ps1
│   └── Discord.ps1
├── .oh-my-posh/custom-posh.json
├── .powershell/Microsoft.PowerShell_profile.ps1
└── .terminal/
    ├── terminal-profile.json
    └── wsl-profile.json
```

Los archivos de configuración de PowerShell y Windows Terminal están en esas
carpetas. El perfil de WSL usa el directorio del usuario de Windows como inicio.

## Uso

Tras formatear, copia esta carpeta al equipo (o clónala desde tu repo) y ejecuta,
como administrador:

```powershell
pwsh -ExecutionPolicy Bypass -File .\main.ps1
```

1. El menú permite instalar todo o elegir cada componente. Al elegir todo,
   instala en orden: PowerShell 7, Oh My Posh + perfil/tema, módulos, Windows
   Terminal, Git, Docker Desktop, NVM, VS Code, Visual Studio y WSL con Ubuntu.
   Visual Studio deja el instalador abierto para elegir cargas de trabajo.
2. Te muestra un menú para elegir qué herramientas opcionales instalar
   (NanaZip, Discord, o las que añadas tú).

## WSL y Windows Terminal

Elige **WSL 2 + Ubuntu + perfil de Windows Terminal** en el menú Devtools, o
**Todo lo anterior**. El script instala Ubuntu si falta, añade o actualiza el
perfil **Ubuntu (WSL)**. Al seleccionarlo en Windows Terminal, arranca
en el directorio de Windows del usuario que ejecuta el instalador, por ejemplo
`/mnt/c/Users/josem`. Si Windows solicita un reinicio, reinicia y abre Ubuntu
una vez para crear el usuario Linux. Vuelve a ejecutar la opción si la
instalación quedó pendiente tras el reinicio.

## Añadir una nueva herramienta

**Devtools:** crea `scripts\0N-nombre.ps1` siguiendo el patrón de los
existentes y añádela a `$devtoolsScripts` en `main.ps1`.

**Opcional (aparece en el menú):** crea `optional\Nombre.ps1` siguiendo el
patrón de `NanaZip.ps1` / `Discord.ps1` y añade una línea al hashtable
`$optionalApps` en `main.ps1`.

Para instalar cualquier paquete nuevo solo necesitas su Id de winget:

```powershell
Install-WingetPackage -Id 'Publisher.Paquete' -Name 'Nombre bonito'
# o, si necesitas que el instalador se muestre (login, wizard, etc.):
Install-WingetPackage -Id 'Publisher.Paquete' -Name 'Nombre bonito' -Interactive
```
