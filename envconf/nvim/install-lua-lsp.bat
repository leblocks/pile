@echo on
set LUA_SERVER_VERSION=3.6.25
set SCRIPT_DIR=%~dp0
set PATH_TO_LANGUAGE_TOOLS=%USERPROFILE%\language-tools
set LUA_LANGUAGE_TOOLS=%PATH_TO_LANGUAGE_TOOLS%\lua

if not exist %PATH_TO_LANGUAGE_TOOLS%\ (
    mkdir %PATH_TO_LANGUAGE_TOOLS%
)

if exist %LUA_LANGUAGE_TOOLS%\ (
    rmdir /S /Q %LUA_LANGUAGE_TOOLS%
)

mkdir %LUA_LANGUAGE_TOOLS%
cd %LUA_LANGUAGE_TOOLS%

rem installing lua-language-server
call curl -LO https://github.com/LuaLS/lua-language-server/releases/download/%LUA_SERVER_VERSION%/lua-language-server-%LUA_SERVER_VERSION%-win32-x64.zip
mkdir lua-language-server
call unzip lua-language-server-%LUA_SERVER_VERSION%-win32-x64.zip -d lua-language-server
del /Q lua-language-server-%LUA_SERVER_VERSION%-win32-x64.zip
for /F "tokens=*" %%g in ('dir /B /S lua-language-server.exe') do (setx LUA_LANGUAGE_SERVER %%g)

rem installing lua debugger TODO

cd %SCRIPT_DIR%
