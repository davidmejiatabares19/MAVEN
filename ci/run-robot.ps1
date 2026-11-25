$ErrorActionPreference = 'Stop'
$pyDir = Join-Path $PWD '.tools/python'
$python = Join-Path $pyDir 'python.exe'

if (-not (Test-Path $python)) {
    New-Item -ItemType Directory -Force -Path $pyDir | Out-Null
    $zip = Join-Path $PWD '.tools/python-embed.zip'
    Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.13.17/python-3.13.17-embed-amd64.zip' -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $pyDir -Force
    $pth = Join-Path $pyDir 'python313._pth'
    $lines = Get-Content $pth
    $lines = $lines -replace '^#import site', 'import site'
    $lines += 'Lib'
    $lines += 'Lib/site-packages'
    Set-Content -Path $pth -Value $lines
    New-Item -ItemType Directory -Force -Path (Join-Path $pyDir 'Lib/site-packages') | Out-Null
    $getPip = Join-Path $PWD '.tools/get-pip.py'
    Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile $getPip
    & $python $getPip --disable-pip-version-check
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

& $python -m pip install --disable-pip-version-check robotframework
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $python -m robot --outputdir target/robot tests/Clientes.robot
exit $LASTEXITCODE
