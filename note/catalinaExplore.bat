@echo off

setlocal

rem 通过startup.bat 过来，没有参数。因此调用 mainEntry 方法
if not ""%1"" == ""run"" goto mainEntry

:mainEntry
del /Q "%TEMP%\%~nx0.run" >NUL 2>&1

set "CURRENT_DIR=%cd%"
rem 环境变量存在，调用 gotHome
if not "%CATALINA_HOME%" == "" goto gotHome


:gotHome

if exist "%CATALINA_HOME%\bin\catalina.bat" goto okHome
echo The CATALINA_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto end

:okHome

rem %CATALINA_BASE% 变量为空，则为它设置 环境变量 在调用gotBase
if not "%CATALINA_BASE%" == "" echo goto gotBase
set "CATALINA_BASE=%CATALINA_HOME%"
:gotBase


if "%CATALINA_HOME%" == "%CATALINA_HOME:;=%" goto homeNoSemicolon
echo Using CATALINA_HOME:   "%CATALINA_HOME%"
echo Unable to start as CATALINA_HOME contains a semicolon (;) character
goto end

:homeNoSemicolon

if "%CATALINA_BASE%" == "%CATALINA_BASE:;=%" goto baseNoSemicolon
echo Using CATALINA_BASE:   "%CATALINA_BASE%"
echo Unable to start as CATALINA_BASE contains a semicolon (;) character
goto end

:baseNoSemicolon


set CLASSPATH=

rem 不存在调用 checkSetenvHome
if not exist "%CATALINA_BASE%\bin\setenv.bat"  goto checkSetenvHome
echo call "%CATALINA_BASE%\bin\setenv.bat"
echo goto setenvDone

:checkSetenvHome
rem 不存在，继续往下走
if exist "%CATALINA_HOME%\bin\setenv.bat" echo call "%CATALINA_HOME%\bin\setenv.bat"

:setenvDone

rem 调用 okSetclasspath
if exist "%CATALINA_HOME%\bin\setclasspath.bat" goto okSetclasspath
echo Cannot find "%CATALINA_HOME%\bin\setclasspath.bat"
echo This file is needed to run this program
goto end

:okSetclasspath
rem 这里直接调用setclasspath.bat，没有参数。设置环境变量JAVA_HOME和JRE_HOME
call "%CATALINA_HOME%\bin\setclasspathExplore.bat" %1

echo The status code returned is : "%errorlevel%"
if errorlevel 1  goto end

rem Add on extra jar file to CLASSPATH
rem Note that there are no quotes as we do not want to introduce random
rem quotes into the CLASSPATH
rem 执行 emptyClasspath
if "%CLASSPATH%" == "" goto emptyClasspath
echo set "CLASSPATH=%CLASSPATH%;"

:emptyClasspath
rem 这里直接开始调用java程序 jar 包。源码路径：java/org/apache/catalina/startup/Bootstrap.java
rem Bootstrap类的主要作用是初始化Tomcat的类加载器，并创建Catalina，这是一个启动类，负责解析server.xml、创建相应组件，并调用Server组件的init、start方法，这样整个Tomcat就启动起来了。
rem 此外，Bootstrap还负责处理一些异常情况，例如当通过“Ctrl + C”关闭Tomcat时。Bootstrap类似于导火线，是tomcat启动的前奏。执行的起点就是bootstrap类的中的main()开始。
set "CLASSPATH=%CLASSPATH%%CATALINA_HOME%\bin\bootstrap.jar"

if not "%CATALINA_TMPDIR%" == "" echo goto gotTmpdir
echo set "CATALINA_TMPDIR=%CATALINA_BASE%\temp"
pause > nul


:end
