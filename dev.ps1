$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSCommandPath
$backendDir = Join-Path $root "backend"
$frontendDir = Join-Path $root "frontend"
$envFile = Join-Path $root ".env.local"

if (-not (Test-Path $backendDir)) { throw "Missing folder: $backendDir" }
if (-not (Test-Path $frontendDir)) { throw "Missing folder: $frontendDir" }

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        if (-not $line) { return }
        if ($line.StartsWith("#")) { return }
        $parts = $line.Split("=", 2)
        if ($parts.Count -ne 2) { return }
        $key = $parts[0].Trim()
        $value = $parts[1].Trim()
        if ($key) { Set-Item -Path "Env:$key" -Value $value }
    }
}

if (-not $env:DB_PASSWORD) {
    throw "DB_PASSWORD is empty. Set it in .env.local (recommended)."
}

if (-not $env:SERVER_PORT) {
    $env:SERVER_PORT = "8081"
}

$port = [int]$env:SERVER_PORT
while (Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue) {
    $port++
    if ($port -gt 8090) {
        throw "No free port found in 8081-8090. Set SERVER_PORT manually (e.g. in .env.local)."
    }
}
$env:SERVER_PORT = $port.ToString()

function Get-Java17Home {
    if ($env:JAVA17_HOME -and (Test-Path $env:JAVA17_HOME)) { return $env:JAVA17_HOME }

    $jdksRoot = Join-Path $env:USERPROFILE ".jdks"
    if (-not (Test-Path $jdksRoot)) { return $null }

    $candidates = @(
        Get-ChildItem -Directory $jdksRoot -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -like "ms-17.*" -or $_.Name -like "openjdk-17.*" } |
            Sort-Object Name -Descending
    )

    return $candidates[0].FullName
}

$java17Home = Get-Java17Home
if (-not $java17Home) {
    throw "No JDK 17 found. Install JDK 17 and set JAVA17_HOME (or put it under $env:USERPROFILE\.jdks)."
}

$backendCmd = "set ""JAVA_HOME=$java17Home"" && set ""PATH=$java17Home\bin;%PATH%"" && cd /d ""$backendDir"" && mvn -DskipTests spring-boot:run"
$frontendCmd = "cd /d ""$frontendDir"" && npm run dev"

Start-Process -FilePath "cmd.exe" -ArgumentList @("/k", $backendCmd)
Start-Process -FilePath "cmd.exe" -ArgumentList @("/k", $frontendCmd)

Write-Host "Started:"
Write-Host " - backend:  mvn -DskipTests spring-boot:run  (JDK 17: $java17Home, cwd: $backendDir)"
Write-Host " - frontend: npm run dev                  (cwd: $frontendDir)"
Write-Host " - backend port: $env:SERVER_PORT"
Write-Host "Close the spawned windows / terminate the processes to stop."
