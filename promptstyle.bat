@echo off

REM Copyright (C) Nurudin Imsirovic <github.com/oxou>
REM CLI script for promptstyle
REM Created: 2023-04-04 08:38 AM
REM Updated: 2023-04-04 01:38 PM

pushd %~dp0

set arg1=%1
set arg2=%2
goto block1

:block1
if [%arg1%] EQU []       goto cli_help
if [%arg1%] EQU [help]   goto cli_help
if [%arg1%] EQU [-help]  goto cli_help
if [%arg1%] EQU [--help] goto cli_help
if [%arg1%] EQU [/?]     goto cli_help
if [%arg1%] EQU [?]      goto cli_help
if [%arg1%] EQU [-h]     goto cli_help
if [%arg1%] EQU [-H]     goto cli_help
if [%arg1%] EQU [--h]    goto cli_help
if [%arg1%] EQU [--H]    goto cli_help
goto block2

:cli_help
echo.Usage: promptstyle ^<option ...arguments^>
echo.  N      - Apply the style index N
echo.  help   - Print this help
echo.  reset  - Reset prompt to the Windows default
echo.  list   - List all styles
echo.  list N - List style index N
popd
exit /B 0

:block2
if [%arg1%] EQU [reset] goto reset_style
goto block3

:reset_style
prompt $P$G
setx PROMPT $P$G >nul
popd
exit /B 0

:block3
if [%arg1%] EQU [list] goto check_styles
goto check_style

:check_styles
if not exist "style" goto :no_style_dir
goto list_styles

:no_style_dir
echo.Error: No "style" folder found. Can't list styles.
popd
exit /B 4

:list_styles
if [%arg2%] NEQ [] goto check_single_style
for /f "delims=" %%i in ('dir /a /b style\*.dem') do (
    type style\%%i
)
popd
exit /B 8

:check_single_style
if not exist style\%arg2%.bat goto :no_style_arg2
goto list_single_style

:list_single_style
type style\%arg2%.dem
popd
exit /B 0

:check_style
if not exist style\%arg1%.bat goto :no_style
goto apply_style

:no_style_arg2
echo.Error: No style under the index: %arg2%
popd
exit /B 16

:no_style
echo.Error: No style under the index: %arg1%
popd
exit /B 16

:apply_style
call style\%arg1%.bat
popd
exit /B 0
