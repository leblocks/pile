@echo on
set SCRIPT_DIR=%cd%
set PATH_TO_LANGUAGE_TOOLS=%USERPROFILE%\language-tools
set BASH_LANGUAGE_TOOLS=%PATH_TO_LANGUAGE_TOOLS%\bash

if not exist %PATH_TO_LANGUAGE_TOOLS%\ (
    mkdir %PATH_TO_LANGUAGE_TOOLS%
)

if exist %BASH_LANGUAGE_TOOLS%\ (
    rmdir /S /Q %BASH_LANGUAGE_TOOLS%
)

mkdir %BASH_LANGUAGE_TOOLS%
cd %BASH_LANGUAGE_TOOLS%

call npm init -y
call npm install bash-language-server

for /F "tokens=*" %%g in ('dir /B /S bash-language-server.cmd') do (setx BASH_LANGUAGE_SERVER %%g)

cd %SCRIPT_DIR%
