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
call "%EXECUTABLE%" start %CMD_LINE_ARGS%

rem 不加这个会窗口一闪而过
pause > nul
rem okHome 结束
goto end


rem 任意键关闭窗口
pause > nul