@echo on

set SCRIPT_DIR=%cd%
set LINK_TO_NVIM_CONFIG=%USERPROFILE%\AppData\Local\nvim
set PACKER_CLONE_PATH=%USERPROFILE%\AppData\Local\nvim-data\site\pack\packer\start\packer.nvim

rem create link to the config file
if exist %LINK_TO_NVIM_CONFIG%\ (
  echo link already exists, skipping
) else (
  echo creating link from  %LINK_TO_NVIM_CONFIG%
  mklink %LINK_TO_NVIM_CONFIG% %SCRIPT_DIR%\config /D
)

rem bootstrap packer and install plugins
if exist %PACKER_CLONE_PATH%\ (
    echo packer already installed, no need for bootstrap
) else (
    echo packer isn't installed, clonning
    git clone --depth 1 https://github.com/wbthomason/packer.nvim %PACKER_CLONE_PATH%
)

rem headless plugin installation
nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"

set PATH_TO_LANGUAGE_TOOLS=%USERPROFILE%\language-tools

if not exist %PATH_TO_LANGUAGE_TOOLS%\ (
    mkdir %PATH_TO_LANGUAGE_TOOLS%
)

call install-lua-lsp.bat
call install-bash-lsp.bat
call install-csharp-lsp.bat
call install-python-lsp.bat
call install-typescript-lsp.bat

