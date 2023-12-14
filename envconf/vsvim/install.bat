@echo on

set SCRIPT_DIR=%~dp0
set LINK_TO_VSVIM_CONFIG=%USERPROFILE%\.vsvimrc

rem create link to the config file
if exist %LINK_TO_VSVIM_CONFIG% (
  echo link already exists, skipping
) else (
  echo creating link from %SCRIPT_DIR%\.vsvimrc to %LINK_TO_VSVIM_CONFIG%
  mklink %LINK_TO_VSVIM_CONFIG% %SCRIPT_DIR%\.vsvimrc
)
