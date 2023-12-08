@echo off
rem @echo off 可以让打印之后不关闭窗口，且必须放在第一位

rem setlocal 和 endlocal 中间的值可以被视为此区域类的局部变量

rem 将当前文件所在的路径赋值给%cd%，等号两边可以交换
set "%cd%=CURRENT_DIR"
rem 打印拼接
echo "CURRENT_DIR: " %cd%
echo "CATALINA_HOME: " %CATALINA_HOME%
rem %cd% 不为空，则跳转到gotHome方法
 if not "%cd%" == "" goto gotHome
rem gotHome开始
:gotHome
echo gotHome
rem 文件存在，则跳转到okHome
if exist "%cd%\studyBat.bat" goto okHome
rem gotHome 方法结束
goto end


rem okHome开始
:okHome
echo okHome

rem %1 表示脚本的第一个参数
rem echo %1
set CMD_LINE_ARGS=%CMD_LINE_ARGS% "1" "2"
for %%i in (%CMD_LINE_ARGS%) do (
    echo Argument: %%i
)
rem 将参数数组中的第一个参数移到数组的最后一个位置，并将其他参数向前移动。没看懂
rem shift

rem 调用另一个文件，传入参数
rem call "%EXECUTABLE%" start %CMD_LINE_ARGS%

rem ========================================================以下分析来自 Catalina.bat================================================================================


rem 环境变量的TEMP
echo "%TEMP%"
rem %~nx0 是当前文件名.后缀
echo "%TEMP%\%~nx0"
rem %~nx0.run 是当前文件名.后缀.run
echo "%TEMP%\%~nx0.run"
rem 将Y写入这个文件中，不会追加，会覆盖内容
echo Y>"%TEMP%\%~nx0.run"
rem 同上
echo Y>"%TEMP%\%~nx0.Y"
rem 当前文件所在的路径，包括文件名和后缀
echo "%~f0"
rem %* 表示所有参数传给，call的文件，参数从<后面的文件中获取
rem call "%~f0" %* <"%TEMP%\%~nx0.Y"

rem 删除文件或者目录，/Q 表示在删除多个文件时不询问确认。>NUL 表示重定向输出到NUL中，什么到看不到；2表示错误输出，&1标准输出。
rem 整行的含义是删除%TEMP%\catalina.bat.Y ，把错误输出的到标准输出，在输出到NUL
rem del /Q "%TEMP%\%~nx0.Y" >NUL 2>&1
rem exit，退出批处理脚本，/B 退出时不会显示任何消息和提示。"6" 返回的状态码
rem exit /B "6"

echo  "CATALINA_HOME" "%CATALINA_HOME%"
rem 删除变量中 所有 ";"
echo "%CATALINA_HOME:;=%"

if not ""%1"" == ""run"" echo "hhh"
if not "%CATALINA_HOME%" == "" echo "gg"
if exist "%CATALINA_HOME%\bin\catalina.bat" echo "okHome"
if not "%CATALINA_BASE%" == "" echo "gotBase"
if "%CATALINA_HOME%" == "%CATALINA_HOME:;=%" echo "homeNoSemicolon"
set "CATALINA_BASE=%CATALINA_HOME%"
if "%CATALINA_BASE%" == "%CATALINA_BASE:;=%" echo "baseNoSemicolon"
if not exist "%CATALINA_BASE%\bin\setenv.bat" echo "checkSetenvHome"
if exist "%CATALINA_HOME%\bin\setenv.bat" echo "call %CATALINA_HOME%\bin\setenv.bat"
if exist "%CATALINA_HOME%\bin\setclasspath.bat" echo "okSetclasspath"
echo "%CATALINA_HOME%\bin\setclasspath.bat"

rem ================================================================以下分析来自setclasspath.bat========================================================================



rem 不加这个会窗口一闪而过
pause > nul
rem okHome 结束
goto end


rem 任意键关闭窗口
pause > nul