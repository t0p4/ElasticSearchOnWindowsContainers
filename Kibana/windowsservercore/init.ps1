function AddToKibanaConfig{
    param([string] $key, [string] $value)
    
    $configPath = 'C:\kibana\config\kibana.yml'

    $regexEscapedKey = $key.replace(".","\.");
    $in = '^.?' + $regexEscapedKey + '.*$'

    $out = $key + ": " + $value
    (Get-Content $configPath) -replace $in, $out | Set-Content $configPath
}


$kibana_vars=@(
    "console.enabled",
    "console.proxyConfig",
    "console.proxyFilter",
    "elasticsearch.customHeaders",
    "elasticsearch.password",
    "elasticsearch.pingTimeout",
    "elasticsearch.preserveHost",
    "elasticsearch.requestHeadersWhitelist",
    "elasticsearch.requestTimeout",
    "elasticsearch.shardTimeout",
    "elasticsearch.ssl.ca",
    "elasticsearch.ssl.cert",
    "elasticsearch.ssl.certificate",
    "elasticsearch.ssl.certificateAuthorities",
    "elasticsearch.ssl.key",
    "elasticsearch.ssl.keyPassphrase",
    "elasticsearch.ssl.verificationMode",
    "elasticsearch.ssl.verify",
    "elasticsearch.startupTimeout",
    "elasticsearch.tribe.customHeaders",
    "elasticsearch.tribe.password",
    "elasticsearch.tribe.pingTimeout",
    "elasticsearch.tribe.requestHeadersWhitelist",
    "elasticsearch.tribe.requestTimeout",
    "elasticsearch.tribe.ssl.ca",
    "elasticsearch.tribe.ssl.cert",
    "elasticsearch.tribe.ssl.certificate",
    "elasticsearch.tribe.ssl.certificateAuthorities",
    "elasticsearch.tribe.ssl.key",
    "elasticsearch.tribe.ssl.keyPassphrase",
    "elasticsearch.tribe.ssl.verificationMode",
    "elasticsearch.tribe.ssl.verify",
    "elasticsearch.tribe.url",
    "elasticsearch.tribe.username",
    "elasticsearch.url",
    "elasticsearch.username",
    "kibana.defaultAppId",
    "kibana.index",
    "logging.dest",
    "logging.quiet",
    "logging.silent",
    "logging.verbose",
    "ops.interval",
    "pid.file",
    "server.basePath",
    "server.defaultRoute",
    "server.host",
    "server.maxPayloadBytes",
    "server.name",
    "server.port",
    "server.ssl.cert",
    "server.ssl.certificate",
    "server.ssl.certificateAuthorities",
    "server.ssl.cipherSuites",
    "server.ssl.clientAuthentication",
    "server.ssl.enabled",
    "server.ssl.key",
    "server.ssl.keyPassphrase",
    "server.ssl.supportedProtocols",
    "status.allowAnonymous",
    "status.v6ApiFormat",
    "tilemap.options.attribution",
    "tilemap.options.maxZoom",
    "tilemap.options.minZoom",
    "tilemap.options.subdomains",
    "tilemap.url",
    "xpack.graph.enabled",
    "xpack.ml.enabled",
    "xpack.monitoring.elasticsearch.password",
    "xpack.monitoring.elasticsearch.url",
    "xpack.monitoring.elasticsearch.username",
    "xpack.monitoring.enabled",
    "xpack.monitoring.kibana.collection.enabled",
    "xpack.monitoring.kibana.collection.interval",
    "xpack.monitoring.max_bucket_size",
    "xpack.monitoring.min_interval_seconds",
    "xpack.monitoring.node_resolver",
    "xpack.monitoring.report_stats",
    "xpack.monitoring.ui.container.elasticsearch.enabled",
    "xpack.reporting.capture.concurrency",
    "xpack.reporting.capture.loadDelay",
    "xpack.reporting.capture.settleTime",
    "xpack.reporting.capture.timeout",
    "xpack.reporting.enabled",
    "xpack.reporting.encryptionKey",
    "xpack.reporting.kibanaApp",
    "xpack.reporting.kibanaServer.hostname",
    "xpack.reporting.kibanaServer.port",
    "xpack.reporting.kibanaServer.protocol",
    "xpack.reporting.queue.indexInterval",
    "xpack.reporting.queue.pollInterval",
    "xpack.reporting.queue.timeout",
    "xpack.security.cookieName",
    "xpack.security.enabled",
    "xpack.security.encryptionKey",
    "xpack.security.secureCookies",
    "xpack.security.sessionTimeout"
)


for ($kibana_var in $kibana_vars) {
    # 'elasticsearch.url' -> 'ELASTICSEARCH_URL'
    $varName = $kibana_var.replace(".","_")

    $env_var = get-childitem env:$varName -ErrorAction SilentlyContinue

    if ($env_var -ne $null) {
        AddToKibanaConfig($kibana_var, $env_var.Value)
    }
}

& c:\kibana\bin\kibana.bat