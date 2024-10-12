@echo off
chcp 65001 > nul
setlocal ENABLEDELAYEDEXPANSION

:: 定义颜色代码
set "red=[31m"
set "green=[32m"
set "yellow=[33m"
set "blue=[34m"
set "magenta=[35m"
set "cyan=[36m"
set "bright_cyan=[36;1m"
set "white=[37m"
set "reset=[0m"

set "CPP_FILE=%1"
for %%I in ("%CPP_FILE%") do (
    set "DIR_NAME=%%~dpI"
    set "BASENAME=%%~nI"
)

set "EXPECT_TXT=!DIR_NAME!expect.txt"
set "INPUT_TXT=!DIR_NAME!input.txt"
set "OUTPUT_TXT=!DIR_NAME!output.txt"
call :log "Test dir: !DIR_NAME!" bright_cyan
call :log ".................Dividing line................." bright_cyan

:: 编译
g++ "%CPP_FILE%" -o "!DIR_NAME!!BASENAME!program.exe"
if errorlevel 1 (
    call :log ".................Dividing line................." bright_cyan
    call :log "compilation result: compilation error, please check" red
    exit /b 1
) else (
    call :log "compilation result: compilation successful" green
)

:: 执行生成的可执行文件，并传递 input.txt 和 output.txt 作为参数
cd /d "!DIR_NAME!"
"!DIR_NAME!!BASENAME!program.exe" <"!INPUT_TXT!"> "!OUTPUT_TXT!"

:: 比较输出文件和期望文件
fc "!OUTPUT_TXT!" "!EXPECT_TXT!" > nul
if errorlevel 1 (
    call :log "Compare result: differences found" red
) else (
    call :log "Compare result: files are identical" green

)

call :log "===============================================" yellow
call :log "♫˚♪• ♫˚♪• ♫˚♪• ♫˚♪•♫˚♪• ♫˚♪• ♫˚♪• ♫˚♪• ♫˚♪•♫˚♪•" blue

:log
set str=%~1
set color=%~2
echo !%color%!%str%!%reset%
goto :eof