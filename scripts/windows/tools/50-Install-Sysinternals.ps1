# 50-Install-Sysinternals.ps1
# Author: Dylan Harvey
# Downloads and installs SysinternalsSuite.
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
$global:ProgressPreference = "SilentlyContinue"

$installPath = "C:\SysinternalsSuite"

function Install-Sysinternals {
    Write-Host "Installing Sysinternals..."
    Write-Host "Downloading Sysinternals..."
    Invoke-WebRequest -Uri "https://download.sysinternals.com/files/SysinternalsSuite.zip" -OutFile "$installPath.zip";
    Write-Host "Extracting Sysinternals..."
    Expand-Archive -Path "$installPath.zip" -DestinationPath $installPath

    Write-Host "Sysinternals installed to $installPath"
}

function Uninstall-Sysinternals {
    Write-Host "Uninstalling Sysinternals..."
    Write-Host "Removing Sysinternals..."
    Remove-Item -Path $installPath -Recurse -Force
    Write-Host "Sysinternals removed."
}

if ($Uninstall) {
    Uninstall-Sysinternals
} else {
    Install-Sysinternals
}
