#!/bin/bash
isql=/data/databases/virtuoso/virtuoso-opensource/bin/isql
endpoint=http://localhost:8890/sparql-graph-crud-auth
graph=$2
file=$1
#curl -D put-in-virtuoso.tmp --digest --user dba:dba --url "${endpoint}?graph-uri=${graph}" -T $file 
#echo "PUT $file into $graph: "$(head -n 1 put-in-virtuoso.tmp)

exec="log_enable(3,1); SPARQL CLEAR GRAPH <$graph>; log_enable (2);DB.DBA.TTLP (file_to_string_output ('$file'), '$graph', '$graph'); checkpoint;"
$isql 1111 dba dba "EXEC=$exec"
