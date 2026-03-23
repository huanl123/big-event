@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
cd /d "%ROOT%"

rem Load .env.local (KEY=VALUE, supports # comments)
if exist "%ROOT%.env.local" (
  for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%ROOT%.env.local") do (
    if not "%%A"=="" set "%%A=%%B"
  )
)

if not defined DB_PASSWORD (
  echo [ERROR] DB_PASSWORD is empty. Put it in .env.local.
  exit /b 1
)

rem Pick JDK 17
if not defined JAVA17_HOME (
  if defined JAVA_HOME set "JAVA17_HOME=%JAVA_HOME%"
)
if not defined JAVA17_HOME for /d %%D in ("%USERPROFILE%\.jdks\ms-17.*") do set "JAVA17_HOME=%%~fD"
if not defined JAVA17_HOME for /d %%D in ("%USERPROFILE%\.jdks\openjdk-17.*") do set "JAVA17_HOME=%%~fD"

if not defined JAVA17_HOME (
  echo [ERROR] No JDK 17 found. Install JDK 17 and set JAVA17_HOME or JAVA_HOME to it.
  exit /b 1
)

rem Pick a free backend port (default 8081, try up to 8090)
if not defined SERVER_PORT set "SERVER_PORT=8081"
set /a PORT=%SERVER_PORT% >nul 2>nul
if not "%errorlevel%"=="0" (
  echo [ERROR] SERVER_PORT must be a number. Current: "%SERVER_PORT%"
  exit /b 1
)
:find_free_port
call :is_port_free %PORT%
if errorlevel 1 (
  set /a PORT+=1
  if %PORT% GTR 8090 (
    echo [ERROR] No free port found in 8081-8090. Set SERVER_PORT manually in .env.local.
    exit /b 1
  )
  goto :find_free_port
)
set "SERVER_PORT=%PORT%"

echo Using JDK 17: %JAVA17_HOME%
echo Using backend port: %SERVER_PORT%

start "backend"  cmd /k "set ""JAVA_HOME=%JAVA17_HOME%"" && set ""PATH=%JAVA17_HOME%\bin;%PATH%"" && cd /d ""%ROOT%backend"" && mvn -DskipTests spring-boot:run"
start "frontend" cmd /k "cd /d ""%ROOT%frontend"" && npm run dev"

echo Started:
echo - backend:  http://localhost:%SERVER_PORT%/
echo - frontend: http://localhost:5173/
exit /b 0

:is_port_free
set "CHECK_PORT=%~1"
powershell -NoProfile -Command "if (Get-NetTCPConnection -LocalPort %CHECK_PORT% -State Listen -ErrorAction SilentlyContinue) { exit 1 } else { exit 0 }" >nul 2>nul
exit /b %errorlevel%
