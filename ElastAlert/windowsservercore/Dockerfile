# Must use Python 2 for ElastAlert: https://github.com/Yelp/elastalert/issues/1425
FROM tonyhernandezatms/python-vcforpython:python-2.7.14_windowsservercore-ltsc2016

# Install ElastAlert
RUN pip install elastalert==0.1.29

# Volume and drive mount
# Mount your custom config and rules to these mount points
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
COPY init.ps1 C:\\ElastAlert\\init.ps1

CMD C:\\ElastAlert\\init.ps1