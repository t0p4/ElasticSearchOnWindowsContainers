if (-not (Test-Path g:\elasticsearch.yml)) {
    Write-Host "Missing config file. Using sample config file."
    Copy-Item c:\elasticsearch\config-example\elasticsearch.yml m:\
}

if (-not (Test-Path g:\jvm.options)) {
    Write-Host "Missing jvm.options file. Using sample jvm.options file."
    Copy-Item c:\elasticsearch\config-example\jvm.options m:\
}

if (-not (Test-Path g:\log4j2.properties)) {
    Write-Host "Missing log4j2.properties file. Using sample config file."
    Copy-Item c:\elasticsearch\config-example\log4j2.properties m:\
}

Write-Host "Starting ElasticSearch"
C:\elasticsearch\bin\elasticsearch.exe -Epath.conf=m:\ -Epath.logs=l:\ -Epath.data=g:\