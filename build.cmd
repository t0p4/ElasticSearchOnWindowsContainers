pushd .
cd .\OpenJDK\nanoserver
start build.cmd
popd
pushd .
cd .\ElasticSearch\nanoserver
start build.cmd
popd
pushd .
cd .\Kibana\windowsservercore
start build.cmd
popd