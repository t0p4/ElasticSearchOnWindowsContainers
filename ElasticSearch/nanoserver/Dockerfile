# escape=`
FROM microsoft/windowsservercore:ltsc2016 AS downloader
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV ES_VERSION="5.5.3" `
    ES_HOME="C:\elasticsearch"

RUN Invoke-WebRequest "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($env:ES_VERSION).zip.sha1" -OutFile 'elasticsearch.zip.sha1' -UseBasicParsing; `
    $env:ES_SHA1 = Get-Content -Raw elasticsearch.zip.sha1; `
    Invoke-WebRequest "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($env:ES_VERSION).zip" -OutFile 'elasticsearch.zip' -UseBasicParsing; `
    if ((Get-FileHash elasticsearch.zip -Algorithm sha1).Hash.ToLower() -ne $env:ES_SHA1) {exit 1}; `
    Expand-Archive elasticsearch.zip -DestinationPath C:\ ; `
    Move-Item c:/elasticsearch-$($env:ES_VERSION) $env:ES_HOME;

# Elasticsearch
FROM openjdk:8-nanoserver-sac2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV ES_VERSION="5.5.3" `
    ES_HOME="C:\elasticsearch"

# Volume and drive mount
VOLUME C:\data C:\logs
RUN Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'G:' -Value '\??\C:\data' -Type String; `
    Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'L:' -Value '\??\C:\logs' -Type String;

EXPOSE 9200 9300
SHELL ["cmd", "/S", "/C"]
CMD ".\bin\elasticsearch.bat"

WORKDIR $ES_HOME
COPY --from=downloader C:\elasticsearch\ .
COPY config ./config
copy sample-data/ ./sample

HEALTHCHECK --interval=5s `
 CMD powershell -command `
    try { `
     $content = (iwr -useb http://localhost:9200/_cat/health).Content; `
     $health = $content.Split(' ')[3]; `
     if ($health -eq 'green' -or $health -eq 'yellow') { return 0 } `
     else { return 1 }; `
    } catch { return 1 }