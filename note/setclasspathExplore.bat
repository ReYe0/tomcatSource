@echo off
rem 没有参数，不执行 goto needJavaHome
if ""%1"" == ""debug"" echo goto needJavaHome
rem 应该是设置的jdk的环境变量，所以不执行 gotJreHome
if not "%JRE_HOME%" == "" echo goto gotJreHome
rem JAVA_HOME 环境变量存在，因此执行 gotJavaHome
if not "%JAVA_HOME%" == ""  goto gotJavaHome
echo Neither the JAVA_HOME nor the JRE_HOME environment variable is defined
echo At least one of these environment variable is needed to run this program
goto exit

:gotJavaHome
rem 没有给定 JRE，检查 JAVA _ HOME 是否可以作为 JRE _ HOME 使用
if not exist "%JAVA_HOME%\bin\java.exe" echo goto noJavaHomeAsJre
rem Use JAVA_HOME as JRE_HOME
set "JRE_HOME=%JAVA_HOME%"
rem 走这里
goto okJava

:okJava
rem 如果用户以前已经设置了已签名的目录，则不要重写该目录
if not "%JAVA_ENDORSED_DIRS%" == "" echo goto gotEndorseddir
rem Java 9不再支持Java . supported .dirs
rem system property. Only try to use it if
rem CATALINA_HOME/endorsed exists.
rem 这里 执行 gotEndorseddir
if not exist "%CATALINA_HOME%\endorsed"  goto gotEndorseddir
echo set "JAVA_ENDORSED_DIRS=%CATALINA_HOME%\endorsed"

:gotEndorseddir

rem 如果用户之前设置了_RUNJAVA，不要重写它
if not "%_RUNJAVA%" == ""  goto gotRunJava
rem 设置调用Java的标准命令。
rem 还要注意JRE_HOME引号可能包含空格
set "_RUNJAVA=%JRE_HOME%\bin\java.exe"

:gotRunJava

rem 如果用户之前设置了_RUNJDB，不要重写它
rem Also note the quoting as JAVA_HOME may contain spaces.
if not "%_RUNJDB%" == "" echo  goto gotRunJdb
set "_RUNJDB=%JAVA_HOME%\bin\jdb.exe"

:gotRunJdb


goto end

:exit
exit /b 1

rem 返回0，是正常的
:end
exit /b 0
