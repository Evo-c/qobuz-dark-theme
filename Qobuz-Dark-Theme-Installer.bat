@echo off
rem Visit https://github.com/Evo-c/qobuz-dark-theme/ for updates
title Qobuz dark theme installer
set "QDTVER=1.0"
if not exist "%~dp0style.css" (
  echo.
  echo Style.css not found in current folder... Will force update
  set "QDTVER=0.1"
)
echo.
echo Current version is %QDTVER%, checking for update...
goto UpdateCheck

:Start
echo.
echo Trying to find your Qobuz folder...
FOR /F "usebackq delims=" %%p IN (`dir "C:\Users\%username%\AppData\Local\Qobuz" /b /ad ^| find "app-5"`) DO (
  set "QBPATH=%%p"
)
echo.
echo Found %QBPATH%!
echo.
if exist "C:\Users\%username%\AppData\Local\Qobuz\%QBPATH%\resources\app\node_modules\qobuz-dwp-ui\dist\style.css.old" (
  del "C:\Users\%username%\AppData\Local\Qobuz\%QBPATH%\resources\app\node_modules\qobuz-dwp-ui\dist\style.css.old"
)
rename "C:\Users\%username%\AppData\Local\Qobuz\%QBPATH%\resources\app\node_modules\qobuz-dwp-ui\dist\style.css" style.css.old
copy %~dp0style.css "C:\Users\%username%\AppData\Local\Qobuz\%QBPATH%\resources\app\node_modules\qobuz-dwp-ui\dist\style.css"
echo.
echo.
echo Success!
echo.
ping 127.0.0.1>nul -n 6
goto End

:UpdateCheck
set "URL=https://raw.githubusercontent.com/Evo-c/qobuz-dark-theme/master/version.txt"
for %%a in (%URL%) do set "File=%%~nxa"
set "DownloadFolder=%Temp%"
:Process
Call :Download "%URL%" "%DownloadFolder%\%File%"
if "%URL%"=="https://raw.githubusercontent.com/Evo-c/qobuz-dark-theme/master/version.txt" (
  for /f "tokens=*" %%A in ('Type "%DownloadFolder%\%File%"') do (set "QDTNEWVER=%%A")
)
if "%QDTNEWVER%" NEQ "%QDTVER%" (
  echo Version %QDTNEWVER% found
  set "DownloadFolder=%~dp0"
  set "File=style.css"
  set "URL=https://raw.githubusercontent.com/Evo-c/qobuz-dark-theme/master/style.css"
  set "QDTVER=%QDTNEWVER%"
  set "QDTUPDATED=true"
  goto Process
)
if "%QDTUPDATED%"=="true" (
  goto Updated
)
if "%QDTNEWVER%"=="%QDTVER%" (
  goto NoUpdate
)
rem ignore this, so it jumps over...
if "one"=="two" (
:Download <Url> <File>
certutil.exe -urlcache -split -f %1 %2 >nullqdti
)
rem ignore this, so it jumps over...
if "three"=="two" (
:NoUpdate
echo Latest version is %QDTNEWVER%, no update needed...
goto Start
)
rem ignore this, so it jumps over...
if "four"=="two" (
:Updated
echo Downloaded style.css for version %QDTVER%
goto Start
)
rem ignore this, so it jumps over...
if "six"=="two" (
:End
if exist "%~dp0nullqdti" (
 del "%~dp0nullqdti"
)
exit
)
