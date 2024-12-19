@echo off

if "%1"=="" (
    echo Usage: z pattern
    echo Jumps to matching directory under %%CODEBASE%%
    exit /b
)

set "pattern=%1"

for /f "tokens=*" %%d in ('dir /b /ad "%CODEBASE%\*"') do (
    for /f "tokens=*" %%e in ('dir /b /ad "%CODEBASE%\%%d\*" ^| findstr /i "%pattern%"') do (
        cd /d "%CODEBASE%\%%d\%%e"
        exit /b 0
    )
)

echo No matches found
exit /b 1
