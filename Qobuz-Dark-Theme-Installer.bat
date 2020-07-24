@echo off
rem Visit https://github.com/Evo-c/qobuz-dark-theme/ for updates
title Qobuz dark theme installer
echo.
set FORCEINS="false"
goto Start

:Start
echo.
echo Trying to find your Qobuz folder...
FOR /F "usebackq delims=" %%p IN (`dir "C:\Users\%username%\AppData\Local\Qobuz" /b /ad ^| find "app-5"`) DO (
  set "QBPATH=%%p"
  set "QDTVER=app-5.4.3-b006"
)
echo.
echo Found %QBPATH%!
echo.
if "%QBPATH%"=="app-5.4.3-b006" (
echo Version supported!
set "URL=https://raw.githubusercontent.com/Evo-c/qobuz-dark-theme/master/style.css"
goto Update
)
goto NotSupported

:NotSupported
cls
color 0c
echo Version not supported, applying the theme could cause bugs and may break the app!
echo Enter yes to continue...
echo.
set /p forceinstall=""
if "%forceinstall%"=="yes" (
cls
color 07
set "URL=https://raw.githubusercontent.com/Evo-c/qobuz-dark-theme/master/style.css"
goto Update
)
echo Aborted
pause
exit

:Install
if exist "C:\Users\%username%\AppData\Local\Qobuz\%QBPATH%\resources\app\node_modules\qobuz-dwp-ui\dist\style.css.old" (
  del "C:\Users\%username%\AppData\Local\Qobuz\%QBPATH%\resources\app\node_modules\qobuz-dwp-ui\dist\style.css.old"
)
rename "C:\Users\%username%\AppData\Local\Qobuz\%QBPATH%\resources\app\node_modules\qobuz-dwp-ui\dist\style.css" style.css.old
copy %~dp0style.css "C:\Users\%username%\AppData\Local\Qobuz\%QBPATH%\resources\app\node_modules\qobuz-dwp-ui\dist\style.css"
echo.
echo.
echo Success!
echo.
ping 127.0.0.1>nul -n 5
goto End

:Update
set "DownloadFolder=%~dp0"
set "File=style.css"
Call :Download "%URL%" "%DownloadFolder%\%File%"
goto Downloaded

echo Error
pause
exit

:Downloaded
if exist "style.css" (
echo Downloaded style.css for version %QDTVER%
goto Install
) else (
echo "Download failed"
pause
exit
)

:End
if exist "%~dp0nullqdti" (
 del "%~dp0nullqdti"
)
exit

:Download <Url> <File>
certutil.exe -urlcache -split -f %1 %2 >nullqdti
