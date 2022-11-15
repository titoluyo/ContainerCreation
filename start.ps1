if (-not (Test-Path Env:AZP_URL)) {
    Write-Error "error: missing AZP_URL environment variable"
    exit 1
}

if (-not (Test-Path Env:AZP_TOKEN_FILE)) {
    if (-not (Test-Path Env:AZP_TOKEN)) {
        Write-Error "error: missing AZP_TOKEN environment variable"
        exit 1
    }

    $Env:AZP_TOKEN_FILE = "\azp\.token"
    $Env:AZP_TOKEN | Out-File -FilePath $Env:AZP_TOKEN_FILE
}

Remove-Item Env:AZP_TOKEN

if ((Test-Path Env:AZP_WORK) -and -not (Test-Path $Env:AZP_WORK)) {
    New-Item -ItemType Directory -Path $Env:AZP_WORK | Out-Null
}

Write-Host "AZP_URL: $Env:AZP_URL"
Write-Host "AZP_WORK: $Env:AZP_WORK"
Write-Host "AZP_POOL: $Env:AZP_POOL"

New-Item -ItemType Directory -Path "\azp\agent" | Out-Null

# Let the agent ignore the token env variables
$Env:VSO_AGENT_IGNORE = "AZP_TOKEN,AZP_TOKEN_FILE"

Set-Location agent

Write-Host "2. Determining matching Azure Pipelines agent..." -ForegroundColor Cyan

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$(Get-Content ${Env:AZP_TOKEN_FILE})"))
Write-Host $base64AuthInfo
$package = Invoke-RestMethod -Headers @{Authorization=("Basic $base64AuthInfo")} -Uri "$(${Env:AZP_URL})/_apis/distributedtask/packages/agent?platform=win-x64" -Method Get
$packageUrl = $package.value[0].downloadUrl

Write-Host $packageUrl

Write-Host "3. Downloading and installing Azure Pipelines agent..." -ForegroundColor Cyan

$wc = new-object System.Net.WebClient
$agentPath = "$(Get-Location)\agent.zip"
Write-Host $agentPath
$wc.DownloadFile($packageUrl, "$(Get-Location)\agent.zip")

Expand-Archive -Path "agent.zip" -DestinationPath "\azp\agent"

try {
    Write-Host "4. Configuring Azure Pipelines agent..." -ForegroundColor Cyan

    .\config.cmd --unattended `
        --agent "$(if (Test-Path Env:AZP_AGENT_NAME) { ${Env:AZP_AGENT_NAME} } else { hostname })" `
        --url "$(${Env:AZP_URL})" `
        --auth PAT `
        --token "$(Get-Content ${Env:AZP_TOKEN_FILE})" `
        --pool "$(if (Test-Path Env:AZP_POOL) { ${Env:AZP_POOL} } else { 'Default' })" `
        --work "$(if (Test-Path Env:AZP_WORK) { ${Env:AZP_WORK} } else { '_work' })" `
        --replace

    Write-Host "5. Running Azure Pipelines agent..." -ForegroundColor Cyan

    .\run.cmd
}
finally {
    Write-Host "Cleanup. Removing Azure Pipelines agent..." -ForegroundColor Cyan

    .\config.cmd remove --unattended `
        --auth PAT `
        --token "$(Get-Content ${Env:AZP_TOKEN_FILE})"
}