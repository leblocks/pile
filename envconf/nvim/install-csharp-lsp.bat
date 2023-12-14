@echo on
set SCRIPT_DIR=%cd%
set PATH_TO_LANGUAGE_TOOLS=%USERPROFILE%\language-tools
set CSHARP_LANGUAGE_TOOLS=%PATH_TO_LANGUAGE_TOOLS%\csharp

if not exist %PATH_TO_LANGUAGE_TOOLS%\ (
    mkdir %PATH_TO_LANGUAGE_TOOLS%
)

if exist %CSHARP_LANGUAGE_TOOLS%\ (
    rmdir /S /Q %CSHARP_LANGUAGE_TOOLS%
)

mkdir %CSHARP_LANGUAGE_TOOLS%
cd %CSHARP_LANGUAGE_TOOLS%

rem installing omnisharp
call curl -LO https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp-win-x64.zip
mkdir omnisharp 
call unzip omnisharp-win-x64.zip -d omnisharp
del /Q omnisharp-win-x64.zip
for /F "tokens=*" %%g in ('dir /B /S OmniSharp.exe') do (setx OMNISHARP_LANGUAGE_SERVER %%g)

rem installing netcoredbg
call curl -LO https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-win64.zip
call tar -xvf  netcoredbg-win64.zip
del /Q netcoredbg-win64.zip
for /F "tokens=*" %%g in ('dir /B /S netcoredbg.exe') do (setx NETCOREDBG_PATH %%g)


cd %SCRIPT_DIR%
