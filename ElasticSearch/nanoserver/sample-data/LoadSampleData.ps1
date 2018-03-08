expand-archive .\logs.zip

get-content .\logstashMappings.json -Raw | Invoke-WebRequest "http://localhost:9200/logstash-2015.05.18" -Method Put

Get-Content .\logs.jsonl -Raw | Invoke-WebRequest "http://localhost:9200/bank/account/_bulk?pretty" -method POST -ContentType "application/x-ndjson"