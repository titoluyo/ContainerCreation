# Set-ExecutionPolicy Bypass -Scope Process -Force;
$securityProtocolSettingsOriginal = [System.Net.ServicePointManager]::SecurityProtocol
try {
  [System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192 -bor 48;
}
catch {
  Write-Warning "Unable to set PowerShell to use TLS 1.2 and TLS 1.1"
}
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
[System.Net.ServicePointManager]::SecurityProtocol = $securityProtocolSettingsOriginal
