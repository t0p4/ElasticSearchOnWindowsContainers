# escape=`
FROM microsoft/windowsservercore:ltsc2016 as download
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV GPG_VERSION 2.3.4

RUN Invoke-WebRequest $('https://files.gpg4win.org/gpg4win-vanilla-{0}.exe' -f $env:GPG_VERSION) -OutFile 'gpg4win.exe' -UseBasicParsing ; `
    Start-Process .\gpg4win.exe -ArgumentList '/S' -NoNewWindow -Wait

RUN @( `
    '94AE36675C464D64BAFA68DD7434390BDBE9B9C5', `
    'FD3A5288F042B6850C66B31F09FE44734EB7990E', `
    '71DCFD284A79C3B38668286BC97EC7A07EDE3FC1', `
    'DD8F2338BAE7501E3DD5AC78C273792F7D83545D', `
    'C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8', `
    'B9AE9905FFD7803F25714661B63B535A4C206CA9', `
    '56730D5401028683275BD23C23EFEFE93C4CFFFE', `
    '77984A986EBC2AA786BC0F66B01FBB92821C587A' `
    ) | foreach { `
      gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $_ ; `
    }

ENV NODE_VERSION 4.5.0

RUN Invoke-WebRequest $('https://nodejs.org/dist/v{0}/SHASUMS256.txt.asc' -f $env:NODE_VERSION) -OutFile 'SHASUMS256.txt.asc' -UseBasicParsing ; `
    gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc

RUN Invoke-WebRequest $('https://nodejs.org/dist/v{0}/node-v{0}-win-x64.zip' -f $env:NODE_VERSION) -OutFile 'node.zip' -UseBasicParsing ; `
    $sum = $(cat SHASUMS256.txt.asc | sls $('  node-v{0}-win-x64.zip' -f $env:NODE_VERSION)) -Split ' ' ; `
    if ((Get-FileHash node.zip -Algorithm sha256).Hash -ne $sum[0]) { Write-Error 'SHA256 mismatch' } ; `
    Expand-Archive node.zip -DestinationPath C:\ ; `
    Rename-Item -Path $('C:\node-v{0}-win-x64' -f $env:NODE_VERSION) -NewName 'C:\nodejs'

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; `
    Invoke-WebRequest 'https://github.com/bitsensor/elastalert/archive/0.0.9.zip' -OutFile 'elastalert.zip' -UseBasicParsing ; `
    Expand-Archive .\elastalert.zip -DestinationPath C:\ ;

ENV KIBANA_VERSION="5.5.3" `
    KIBANA_HOME="C:\kibana"

RUN Invoke-WebRequest "https://artifacts.elastic.co/downloads/kibana/kibana-$($env:KIBANA_VERSION)-windows-x86.zip.sha1" -OutFile 'kibana.zip.sha1' -UseBasicParsing; `
    $env:KIBANA_SHA1 = Get-Content -Raw kibana.zip.sha1; `
    Invoke-WebRequest "https://artifacts.elastic.co/downloads/kibana/kibana-$($env:KIBANA_VERSION)-windows-x86.zip" -OutFile 'kibana.zip' -UseBasicParsing; `
    if ((Get-FileHash kibana.zip -Algorithm sha1).Hash.ToLower() -ne $env:KIBANA_SHA1) {exit 1}; `
    Expand-Archive kibana.zip -DestinationPath C:\; `
    Move-Item c:/kibana-$($env:KIBANA_VERSION)-windows-x86 $env:KIBANA_HOME;

FROM tonyhernandezatms/python-vcforpython:python-2.7.14_windowsservercore-ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV KIBANA_VERSION="5.5.3" `
    KIBANA_HOME="C:\kibana" `
    NPM_CONFIG_LOGLEVEL="info"

COPY --from=download /nodejs /nodejs
copy --from=download /elastalert-0.0.9 /elastalert-0.0.9
RUN $env:PATH = 'C:\nodejs;{0}' -f $env:PATH ; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

WORKDIR C:\elastalert-0.0.9
RUN npm install --quiet ; `
    npm run build ; `
    Copy-Item .\lib c:\elastalert

WORKDIR C:\kibana
COPY init.ps1 .
COPY --from=downloader C:\kibana\ .

RUN .\bin\kibana-plugin.bat install https://git.bitsensor.io/front-end/elastalert-kibana-plugin/builds/artifacts/kibana5/raw/artifact/elastalert-5.5.3-latest.zip?job=build

# Default configuration for host & Elasticsearch URL
RUN (Get-Content ./config/kibana.yml) -replace '#server.host: \"localhost\"', 'server.host: \"0.0.0.0\"' | Set-Content ./config/kibana.yml; `
    (Get-Content ./config/kibana.yml) -replace '#elasticsearch.url: \"http://localhost:9200\"', 'elasticsearch.url: \"http://elasticsearch:9200\"' | Set-Content ./config/kibana.yml

EXPOSE 5601
EXPOSE 3030
ENTRYPOINT ["powershell"]
CMD [".\init.ps1"]

HEALTHCHECK --start-period=30s --interval=10s --retries=5 `
 CMD powershell -command `
    try { `
     $response = iwr -useb http://localhost:5601/app/kibana; `
     if ($response.StatusCode -eq 200) { return 0} `
     else {return 1}; `
    } catch { return 1 }
