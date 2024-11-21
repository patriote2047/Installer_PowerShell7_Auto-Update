# Script d'installation automatique de PowerShell 7
# Auteur: Cascade
# Date: 2024-03-20
# Description: Verifie, telecharge et installe PowerShell 7 si necessaire

# Verification des privileges administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    try {
        Write-Warning "Redemarrage du script avec les privileges administrateur..."
        Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    }
    catch {
        Write-Warning "Impossible de redemarrer en mode administrateur. Erreur: $_"
    }
    exit
}

# Configuration de l'encodage
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

function Write-ColorMessage {
    param(
        [string]$Message,
        [string]$ForegroundColor = 'White'
    )
    Write-Host $Message -ForegroundColor $ForegroundColor
}

function Test-PowerShell7 {
    try {
        # Verifie si PowerShell 7 est deja installe
        $pwsh = Get-Command pwsh -ErrorAction Stop
        if ($pwsh) {
            $version = & $pwsh -NoProfile -Command '$PSVersionTable.PSVersion.ToString()'
            Write-ColorMessage "PowerShell $version est deja installe dans: $($pwsh.Source)" 'Green'
            return $true
        }
    }
    catch {
        # Verifie directement le chemin d'installation
        $pwshPath = "C:\Program Files\PowerShell\7\pwsh.exe"
        if (Test-Path $pwshPath) {
            Write-ColorMessage "PowerShell 7 est installe mais n'est pas dans le PATH" 'Yellow'
            return $true
        }
        Write-ColorMessage "PowerShell 7 n'est pas installe" 'Yellow'
        return $false
    }
}

function Get-LatestPowerShell7Version {
    try {
        # Recupere la derniere version stable depuis l'API GitHub
        $apiUrl = 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'
        $release = Invoke-RestMethod -Uri $apiUrl -Headers @{
            'Accept' = 'application/vnd.github.v3+json'
        }
        $version = $release.tag_name.TrimStart('v')
        Write-ColorMessage "Derniere version stable disponible: $version" 'Cyan'
        return $version
    }
    catch {
        $defaultVersion = '7.4.1'
        Write-ColorMessage "Impossible de recuperer la derniere version. Utilisation de la version par defaut: $defaultVersion" 'Yellow'
        return $defaultVersion
    }
}

function Add-PowerShell7ToPath {
    $pwshPath = "C:\Program Files\PowerShell\7"
    $currentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    
    if ($currentPath -notlike "*$pwshPath*") {
        try {
            [Environment]::SetEnvironmentVariable('Path', "$currentPath;$pwshPath", 'User')
            Write-ColorMessage "PowerShell 7 ajoute au PATH avec succes" 'Green'
            return $true
        }
        catch {
            Write-ColorMessage "Erreur lors de l'ajout au PATH: $_" 'Red'
            return $false
        }
    }
    else {
        Write-ColorMessage "PowerShell 7 est deja dans le PATH" 'Green'
        return $true
    }
}

function Install-PowerShell7 {
    param (
        [string]$Version = (Get-LatestPowerShell7Version)
    )

    $tempDir = [System.IO.Path]::GetTempPath()
    $installerPath = Join-Path $tempDir "PowerShell-$Version-win-x64.msi"
    $downloadUrl = "https://github.com/PowerShell/PowerShell/releases/download/v$Version/PowerShell-$Version-win-x64.msi"

    try {
        # Telechargement avec barre de progression
        Write-ColorMessage "Telechargement de PowerShell $Version..." 'Yellow'
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($downloadUrl, $installerPath)
        
        if (Test-Path $installerPath) {
            Write-ColorMessage "Telechargement termine avec succes" 'Green'
            
            # Installation
            Write-ColorMessage "Installation de PowerShell $Version..." 'Yellow'
            $arguments = @(
                "/i",
                "`"$installerPath`"",
                "/quiet",
                "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1",
                "ENABLE_PSREMOTING=1",
                "REGISTER_MANIFEST=1"
            )
            
            $process = Start-Process msiexec.exe -ArgumentList $arguments -Wait -NoNewWindow -PassThru
            
            if ($process.ExitCode -eq 0) {
                Write-ColorMessage "Installation terminee avec succes!" 'Green'
                
                # Ajout au PATH
                if (Add-PowerShell7ToPath) {
                    Write-ColorMessage "Configuration terminee avec succes!" 'Green'
                    Write-ColorMessage "IMPORTANT: Veuillez redemarrer votre terminal pour utiliser PowerShell 7" 'Yellow'
                }
            }
            else {
                throw "L'installation a echoue avec le code: $($process.ExitCode)"
            }
        }
        else {
            throw "Le fichier d'installation n'a pas ete telecharge correctement"
        }
    }
    catch {
        Write-ColorMessage "Erreur lors de l'installation: $_" 'Red'
        if (Test-Path $installerPath) {
            Write-ColorMessage "Suppression du fichier d'installation temporaire..." 'Yellow'
            Remove-Item $installerPath -Force
        }
        exit 1
    }
    finally {
        # Nettoyage
        if (Test-Path $installerPath) {
            Remove-Item $installerPath -Force
            Write-ColorMessage "Nettoyage des fichiers temporaires termine" 'Green'
        }
    }
}

# Programme principal
Clear-Host
Write-ColorMessage "=== Installation de PowerShell 7 ===" 'Cyan'
Write-ColorMessage "Verification de l'installation existante..." 'Yellow'

if (-not (Test-PowerShell7)) {
    do {
        Write-ColorMessage "Voulez-vous installer PowerShell 7? (O/N)" 'Cyan'
        $confirmation = Read-Host
        $confirmation = $confirmation.ToUpper()
    } while ($confirmation -notin @('O', 'N'))

    if ($confirmation -eq 'O') {
        Install-PowerShell7
    }
    else {
        Write-ColorMessage "Installation annulee" 'Yellow'
        exit 0
    }
}

# Test final
if (Test-PowerShell7) {
    Write-ColorMessage "`nPowerShell 7 est pret a etre utilise!" 'Green'
    Write-ColorMessage "Pour commencer a l'utiliser, ouvrez un nouveau terminal et tapez 'pwsh'" 'Cyan'
}

# Pause avant de quitter
Write-ColorMessage "`nAppuyez sur une touche pour fermer..." 'Yellow'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
