@echo off
setlocal
rem Detecta JAVA_HOME desde java.exe si el usuario no lo configuro manualmente.
if defined JAVA_HOME goto check_java
if exist "C:\Program Files\Java\jdk-21.0.12.1\bin\java.exe" set "JAVA_HOME=C:\Program Files\Java\jdk-21.0.12.1"
if defined JAVA_HOME goto check_java
for /f "delims=" %%J in ('where java 2^>nul') do (
  for %%I in ("%%~dpJ..") do set "JAVA_HOME=%%~fI"
  goto check_java
)
echo No se encontro Java. Instala un JDK 11 o superior y vuelve a ejecutar este archivo.
echo Luego configura JAVA_HOME, por ejemplo: C:\Program Files\Java\jdk-11
exit /b 1
:check_java
if not exist "%JAVA_HOME%\bin\java.exe" (
  echo JAVA_HOME apunta a una carpeta sin bin\java.exe: "%JAVA_HOME%"
  echo Configura JAVA_HOME con la carpeta principal de tu JDK, no con la carpeta bin.
  exit /b 1
)
set "MAVEN_VERSION=3.9.9"
set "MAVEN_HOME=%USERPROFILE%\.m2\wrapper\apache-maven-%MAVEN_VERSION%"
set "MAVEN_BIN=%MAVEN_HOME%\bin\mvn.cmd"
if exist "%MAVEN_BIN%" goto run_maven
set "DOWNLOAD_DIR=%USERPROFILE%\.m2\wrapper\downloads"
set "MAVEN_ZIP=%DOWNLOAD_DIR%\apache-maven-%MAVEN_VERSION%-bin.zip"
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"
echo Maven no esta instalado. Descargando Apache Maven %MAVEN_VERSION%...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://archive.apache.org/dist/maven/maven-3/%MAVEN_VERSION%/binaries/apache-maven-%MAVEN_VERSION%-bin.zip' -OutFile '%MAVEN_ZIP%'"
if errorlevel 1 (
  echo No se pudo descargar Maven. Verifica tu conexion a Internet e intenta de nuevo.
  exit /b 1
)
echo Extrayendo Maven...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%MAVEN_ZIP%' -DestinationPath '%USERPROFILE%\.m2\wrapper' -Force"
if errorlevel 1 (
  echo No se pudo extraer Maven.
  exit /b 1
)
:run_maven
call "%MAVEN_BIN%" %*
exit /b %ERRORLEVEL%


