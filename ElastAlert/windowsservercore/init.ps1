if (-not (Test-Path g:\config.yaml)) {
    Write-Host "Missing config file. Using sample config file."
    Copy-Item c:\elastalert\config-example\config.yaml g:\
}

if (-not (Test-Path -Path l:\*.yaml)) {
    Write-Host "Missing rule files. Using sample rules."
    Copy-Item c:\elastalert\rules-example\*.yaml l:\
}

Write-Host "Starting ElastAlert"
C:\Python\Scripts\elastalert.exe --verbose --config g:\config.yaml