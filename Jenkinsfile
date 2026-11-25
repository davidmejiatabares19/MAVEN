pipeline {
    agent any

    triggers { pollSCM('H/5 * * * *') }
    options {
        skipDefaultCheckout(true)
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        SONAR_PROJECT_KEY = 'clientes-web'
        APP_URL = 'http://127.0.0.1:8081/'
        TOMCAT_URL = 'http://127.0.0.1:8090/clientes/'
        TOMCAT_BASE = 'D:/INSTALADORES/TOMCAT'
    }

    stages {
        stage('Revisar main') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/davidmejiatabares19/MAVEN.git']]])
                echo 'Código de la rama main descargado.'
            }
        }

        stage('Compilar y analizar con SonarQube') {
            steps {
                script {
                    try {
                        withSonarQubeEnv('SonarQubeLocal') {
                            bat 'call mvnw.cmd -B clean verify org.sonarsource.scanner.maven:sonar-maven-plugin:5.0.0.4389:sonar -Dsonar.projectKey=%SONAR_PROJECT_KEY% -Dsonar.projectName=Clientes-Web'
                        }
                    } catch (err) {
                        echo 'El código no cumple con SonarQube o falló el análisis.'
                        throw err
                    }
                }
            }
        }

        stage('Quality Gate SonarQube') {
            steps {
                script {
                    try {
                        timeout(time: 5, unit: 'MINUTES') {
                            def qualityGate = waitForQualityGate()
                            if (qualityGate.status != 'OK') {
                                error "Quality Gate: ${qualityGate.status}"
                            }
                        }
                        echo 'El código cumple con SonarQube (Quality Gate OK).'
                    } catch (err) {
                        echo 'El código no cumple con SonarQube (Quality Gate rechazado o no disponible).'
                        throw err
                    }
                }
            }
        }

        stage('Iniciar aplicación para las pruebas') {
            steps {
                writeFile file: 'start-app.ps1', text: '''
$jar = Join-Path $PWD 'target/clientes-web-1.0.0.war'
$process = Start-Process -FilePath 'java.exe' -ArgumentList @('-jar', $jar, '--server.port=8081') -PassThru -WindowStyle Hidden
Set-Content -Path 'app.pid' -Value $process.Id
'''
                bat 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File start-app.ps1'
                writeFile file: 'wait-app.ps1', text: '''
$ready = $false
for ($i = 0; $i -lt 40; $i++) {
  try { $r = Invoke-WebRequest -Uri $env:APP_URL -UseBasicParsing -TimeoutSec 3; if ($r.StatusCode -eq 200) { $ready = $true; break } } catch { Start-Sleep -Seconds 2 }
}
if (-not $ready) { Write-Error 'La aplicación no inició en el puerto 8081'; exit 1 }
'''
                bat 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File wait-app.ps1'
            }
        }

        stage('Pruebas Robot Framework') {
            steps {
                script {
                    try {
                        bat 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File ci/run-robot.ps1'
                        archiveArtifacts artifacts: 'target/robot/**', allowEmptyArchive: false
                        echo 'Las pruebas de Robot Framework pasaron.'
                    } catch (err) {
                        echo 'No pasó las pruebas de Robot Framework.'
                        throw err
                    }
                }
            }
        }

        stage('Desplegar en Tomcat 10') {
            steps {
                writeFile file: 'deploy-tomcat.ps1', text: '''
$ErrorActionPreference = 'Stop'
$base = $env:TOMCAT_BASE
$appBase = Join-Path $base 'webapps'
if (-not (Test-Path $appBase)) { throw "No se encontró el appBase de Tomcat: $appBase" }
Copy-Item 'target/clientes-web-1.0.0.war' (Join-Path $appBase 'clientes.war') -Force
Write-Output 'WAR Jakarta copiado al appBase de Tomcat.'
$ready = $false
for ($i = 0; $i -lt 40; $i++) {
  try { $r = Invoke-WebRequest -Uri $env:TOMCAT_URL -UseBasicParsing -TimeoutSec 3; if ($r.StatusCode -eq 200) { $ready = $true; break } } catch { Start-Sleep -Seconds 2 }
}
if (-not $ready) { throw 'WAR copiado, pero la aplicación no respondió en Tomcat dentro del tiempo esperado.' }
Write-Output "Aplicación desplegada: $env:TOMCAT_URL"
'''
                bat 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File deploy-tomcat.ps1'
            }
        }
    }

    post {
        always {
            bat 'powershell.exe -NoProfile -Command "if (Test-Path app.pid) { Stop-Process -Id (Get-Content app.pid) -Force -ErrorAction SilentlyContinue }"'
        }
    }
}
