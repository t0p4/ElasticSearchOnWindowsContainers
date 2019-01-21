# escape=`
FROM mcr.microsoft.com/windows/servercore:1809 AS downloader
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV ES_VERSION="6.5.4" `
    ES_HOME="C:\elasticsearch"

RUN Invoke-WebRequest "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($env:ES_VERSION).zip.sha512" -OutFile 'elasticsearch.zip.sha512' -UseBasicParsing; `
    $env:ES_SHA512 = Get-Content -Raw elasticsearch.zip.sha512; `
    Invoke-WebRequest "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($env:ES_VERSION).zip" -OutFile 'elasticsearch.zip' -UseBasicParsing; `
    #if ((Get-FileHash elasticsearch.zip -Algorithm sha512).Hash.ToLower() -ne $env:ES_SHA512) {exit 1}; `
    Expand-Archive elasticsearch.zip -DestinationPath C:\ ; `
    Move-Item c:/elasticsearch-$($env:ES_VERSION) $env:ES_HOME;

# Elasticsearch
FROM elk-java
# SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV ES_VERSION="6.5.4" `
    ES_HOME="C:\elasticsearch"

# Volume and drive mount
VOLUME C:\data C:\logs
# RUN Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'G:' -Value '\??\C:\data' -Type String; `
#    Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'L:' -Value '\??\C:\logs' -Type String

EXPOSE 9200 9300
SHELL ["cmd", "/S", "/C"]
CMD ".\bin\elasticsearch.bat"

WORKDIR $ES_HOME
COPY --from=downloader C:\elasticsearch\ .
COPY config ./config

HEALTHCHECK --interval=5s `
 CMD powershell -command `
    try { `
     $content = (iwr -useb http://localhost:9200/_cat/health).Content; `
     $health = $content.Split(' ')[3]; `
     if ($health -eq 'green' -or $health -eq 'yellow') { return 0 } `
     else { return 1 }; `
    } catch { return 1 }