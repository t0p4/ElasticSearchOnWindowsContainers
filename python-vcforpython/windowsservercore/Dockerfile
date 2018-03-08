# Must use Python 2 for ElastAlert: https://github.com/Yelp/elastalert/issues/1425
FROM python:2.7.14-windowsservercore-ltsc2016
ENV PYTHONIOENCODING="UTF-8"

# Flip back to cmd from powershell
SHELL ["cmd", "/S", "/C"]

# Copy dependency. Need to find URL for this.
COPY VCForPython27.msi C:\\TEMP\\VSForPython27.msi

# Install dependency.
RUN C:\\TEMP\\VSForPython27.msi