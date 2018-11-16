#!/bin/bash
function encodeURIComponent {
	perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'
}
queryfile=$1
endpoint=http://localhost:8890/sparql
echo "Querying $endpoint, file $queryfile"
query=`cat $queryfile|encodeURIComponent`
time curl -v "$endpoint" -d query="$query"
