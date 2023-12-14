@echo on
set SCRIPT_DIR=%cd%
set PATH_TO_LANGUAGE_TOOLS=%USERPROFILE%\language-tools
set PYTHON_LANGUAGE_TOOLS=%PATH_TO_LANGUAGE_TOOLS%\python

if not exist %PATH_TO_LANGUAGE_TOOLS%\ (
    mkdir %PATH_TO_LANGUAGE_TOOLS%
)

if exist %PYTHON_LANGUAGE_TOOLS%\ (
    rmdir /S /Q %PYTHON_LANGUAGE_TOOLS%
)

mkdir %PYTHON_LANGUAGE_TOOLS%
cd %PYTHON_LANGUAGE_TOOLS%

call python -m venv venv
call "venv\Scripts\activate.bat"
python -m pip install pyright debugpy
for /F "tokens=*" %%g in ('where pyright-python-langserver') do (setx PYRIGHT_LANGUAGE_SERVER %%g)
for /F "tokens=*" %%g in ('where python ^| findstr .exe') do (setx DEBUGPY_PATH %%g)
call "venv\Scripts\deactivate.bat"
cd %SCRIPT_DIR%
