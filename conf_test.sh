#!/bin/bash

function createconf()
{
cat<<EOF>>/opt/data/splunk/etc/apps/splunk_app_db_connect/local/db_inputs.conf

[tbLog_$1]
connection = test_mysql
disabled = 0
fetch_size = 5000
index = tblog_index
index_time_mode = dbColumn
input_timestamp_column_number = 6
interval = 120
max_rows = 5000
mode = rising
query = SELECT * FROM \`AccessLog\`.\`tbLog_$1\` \\
WHERE lId > ?\\
ORDER BY lId ASC
query_timeout = 30
sourcetype = tbLog
tail_rising_column_number = 1
source = tbLog
EOF

cat<<EOF>>/opt/data/splunk/var/lib/splunk/modinputs/server/splunk_app_db_connect/tblog_$1
{"value":"0","appVersion":"3.1.3","columnType":-5,"timestamp":"`date +"%Y-%m-%dT%H:%M:%S.%3N+08:00"`"}
EOF
}

count=6

while [ $count -lt 60 ];do

 date_conf=`date -d ''$count' days ago' +"%Y%m%d"`
 createconf $date_conf
 count=$((count + 1))
done
echo "finished"
