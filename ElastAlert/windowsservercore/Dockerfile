# Must use Python 2 for ElastAlert: https://github.com/Yelp/elastalert/issues/1425
FROM python:2.7.14-windowsservercore-ltsc2016

# Flip back to cmd from powershell
SHELL ["cmd", "/S", "/C"]

# Copy dependency. Need to find URL for this.
COPY VCForPython27.msi C:\\TEMP\\VSForPython27.msi

# Install dependency.
RUN C:\\TEMP\\VSForPython27.msi

# Install ElastAlert
RUN pip install elastalert

# Volume and drive mount
VOLUME C:\\ElastAlert\\config C:\\ElastAlert\\rules

# Workaround needed: https://blog.sixeyed.com/docker-volumes-on-windows-the-case-of-the-g-drive/
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'G:' -Value '\??\C:\ElastAlert\config' -Type String; \
    Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'L:' -Value '\??\C:\ElastAlert\rules' -Type String

# Volumes on Windows-based containers: When using Windows-based containers, the destination of a volume inside the container must be one of:
#	- a non-existing or empty directory
#	- a drive other than C:
COPY config-example c:\\ElastAlert\\config-example
COPY rules-example c:\\ElastAlert\\rules-example

# Flip back to cmd from powershell
# SHELL ["cmd", "/S", "/C"]

# CMD ["C:\Python\Scripts\elastalert.exe","--verbose","--config","C:\ElastAlert\config-example\config.yaml"]