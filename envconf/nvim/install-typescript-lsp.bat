@echo on
set SCRIPT_DIR=%cd%
set PATH_TO_LANGUAGE_TOOLS=%USERPROFILE%\language-tools
set TYPESCRIPT_LANGUAGE_TOOLS=%PATH_TO_LANGUAGE_TOOLS%\typescript

if not exist %PATH_TO_LANGUAGE_TOOLS%\ (
    mkdir %PATH_TO_LANGUAGE_TOOLS%
)

if exist %TYPESCRIPT_LANGUAGE_TOOLS%\ (
    rmdir /S /Q %TYPESCRIPT_LANGUAGE_TOOLS%
)

mkdir %TYPESCRIPT_LANGUAGE_TOOLS%
cd %TYPESCRIPT_LANGUAGE_TOOLS%

call npm init -y
call npm install typescript typescript-language-server

for /F "tokens=*" %%g in ('dir /B /S typescript-language-server.cmd') do (setx TYPESCRIPT_LANGUAGE_SERVER %%g)

cd %SCRIPT_DIR%
